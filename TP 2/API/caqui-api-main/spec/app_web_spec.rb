ENV['APP_ENV'] = 'test'
ENV['TEST_ENV'] = 'test'

require 'rack/test'
require 'integration_helper'
require 'webmock/rspec'
require_relative '../app'
require_relative '../dominio/paciente'
require_relative '../dominio/sistema'
require_relative '../persistencia/repositorio_pacientes'

describe 'App web' do
  include Rack::Test::Methods

  let(:repo_especialidades) { RepositorioEspecialidades.new }
  let(:repo_medicos) { RepositorioMedicos.new }
  let(:repo_pacientes) { RepositorioPacientes.new }
  let(:repo_turnos) { RepositorioTurnos.new }
  let(:fecha_sistema) { FechaHorario.new('10/06/2025 12:00') }
  let(:medico) { crear_medico }
  let(:paciente) { crear_paciente }
  let(:repo_reputaciones) { RepositorioReputaciones.new }

  def app
    Sinatra::Application
  end

  def consultar_feriados
    get '/proveedor/feriados', {}.to_json, headers_autorizacion
    expect(last_response.status).to eq 200
    JSON.parse(last_response.body)
  end

  def setear_feriados(feriados = [])
    post '/proveedor/feriados', { fecha_feriados: feriados }.to_json, headers_autorizacion
    expect(last_response.status).to eq 200
  end

  def stubear_proveedor_feriados_no_labroables(feriados = [])
    stub_request(:get, %r{#{Regexp.escape(ProveedorFeriadosNoLaborables::URL_API)}/\d{4}})
      .to_return(status: 200, body: feriados.to_json)
  end

  before(:each) do
    stubear_proveedor_feriados_no_labroables
    cambiar_sistema_a_fecha_fija(fecha_sistema)
  end

  def headers_autorizacion
    { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => ENV['AUTH_TOKEN'] }
  end

  def sistema
    app.settings.sistema
  end

  def cambiar_sistema_a_fecha_fija(fecha_horario)
    post_proveedor_fecha(fecha: fecha_horario)
  end

  def proveedor_fecha_fija
    ProveedorFechaFija.new(fecha_sistema)
  end

  def post_proveedor_fecha(fecha: nil, headers: headers_autorizacion)
    body = {}
    body = { fecha_horario: fecha.to_s } unless fecha.nil?
    post '/proveedor/fecha', body.to_json, headers
    expect(last_response.status).to eq 200
  end

  describe 'cambio de proveedor de fecha' do
    def post_proveedor_fecha_fija(fecha_sistema)
      post_proveedor_fecha(fecha: fecha_sistema)
    end

    def post_proveedor_fecha_real
      post_proveedor_fecha
    end

    it 'cambia el proveedor de fecha a una fecha fija' do
      post_proveedor_fecha_fija(fecha_sistema)
      expect(sistema.proveedor_fecha).to be_a(ProveedorFechaFija)
    end

    it 'cambia el proveedor de fecha a una fecha real' do
      post_proveedor_fecha_real
      expect(sistema.proveedor_fecha).to be_a(ProveedorFechaReal)
    end
  end

  describe 'Authorizacion' do
    it 'creo un paciente con auth' do
      post '/paciente', { nombre: 'juan', dni: 21_221, email: 'juan@test.com' }.to_json,
           headers_autorizacion
      expect(last_response.status).to eq 201
    end

    it 'creo un paciente sin auth' do
      post '/paciente', { nombre: 'juan', dni: 21_221, email: 'juan@test.com' }.to_json,
           { 'CONTENT_TYPE' => 'application/json' }
      expect(last_response.status).to eq 401
    end
  end

  it 'creo una especialidad' do
    post '/especialidades', { nombre: 'Clinico', duracion: 15 }.to_json,
         headers_autorizacion
    expect(last_response.status).to eq 201
    expect(JSON.parse(last_response.body)['id']).to be_a(Integer)
  end

  it 'creo un medico' do
    post '/especialidades', { nombre: 'Clinico', duracion: 15 }.to_json, headers_autorizacion
    post '/medicos', { nombre: 'Juan Matrix', especialidad: 'Clinico', matricula: '102_203', trabaja_feriados: false }.to_json,
         headers_autorizacion
    expect(last_response.status).to eq 201
    expect(JSON.parse(last_response.body)['id']).to be_a(Integer)
  end

  describe 'turnos disponibles de un medico' do
    it 'pido los turnos disponibles de un medico que trabaja feriados' do
      fecha_feriado_9_julio = FechaHorario.new('09/07/2025 08:00')
      cambiar_sistema_a_fecha_fija(fecha_feriado_9_julio - 1)

      medico_con_feriados = crear_medico(trabaja_feriados: true)
      get "/turnos/#{medico_con_feriados.id}/0/2", {}, headers_autorizacion
      expect(last_response.status).to eq 200
      fechas_turnos = JSON.parse(last_response.body).map do |turno|
        FechaHorario.new(turno['fecha'])
      end
      expect(fechas_turnos).to all(be >= (fecha_feriado_9_julio))
    end

    it 'pido los turnos disponibles de un medico que no trabaja feriados' do
      fecha_feriado_9_julio = FechaHorario.new('09/07/2025 08:00')
      cambiar_sistema_a_fecha_fija(fecha_feriado_9_julio - 1)

      medico_con_feriados = crear_medico(trabaja_feriados: true)
      get "/turnos/#{medico_con_feriados.id}/0/2", {}.to_json, headers_autorizacion
      expect(last_response.status).to eq 200
      fechas_turnos = JSON.parse(last_response.body).map do |turno|
        FechaHorario.new(turno['fecha'])
      end
      expect(fechas_turnos).to all(be >= (fecha_feriado_9_julio + 1))
    end
  end

  it 'pido la info de un medico' do
    get "/medicos/#{medico.id}", {}, headers_autorizacion
    expect(last_response.status).to eq 200
    expect(JSON.parse(last_response.body)['id']).to eq medico.id
  end

  describe 'reservar turno:' do
    it 'reservo turno valido con medico' do
      paciente = crear_paciente
      post '/reservar', { id_medico: medico.id, fecha: '08/10/2025 10:00', username: paciente.username }.to_json,
           headers_autorizacion
      expect(last_response.status).to eq 201
    end

    it 'reserva de un turno fallida porque existe otro en el mismo horario y no esta cancelado' do
      paciente = crear_paciente
      post '/reservar', { id_medico: medico.id, fecha: '08/10/2025 10:00', username: paciente.username }.to_json,
           headers_autorizacion
      expect(last_response.status).to eq 201

      post '/reservar', { id_medico: medico.id, fecha: '08/10/2025 10:00', username: paciente.username }.to_json,
           headers_autorizacion
      expect(last_response.status).to eq 409
    end

    it 'reservo un turno exitosa y ya existia otro en el mismo horario cancelado' do
      paciente = crear_paciente
      post '/reservar', { id_medico: medico.id, fecha: '08/10/2025 10:00', username: paciente.username }.to_json,
           headers_autorizacion
      response = JSON.parse(last_response.body)
      turno_reservado_id = response['id_turno']
      expect(last_response.status).to eq 201

      post "/turnos/#{turno_reservado_id}/cancelar", {}.to_json, headers_autorizacion
      expect(last_response.status).to eq 200

      post '/reservar', { id_medico: medico.id, fecha: '08/10/2025 10:00', username: paciente.username }.to_json,
           headers_autorizacion
      expect(last_response.status).to eq 201
    end
  end

  it 'registro la asistencia de un paciente' do
    paciente = crear_paciente
    repo_turnos.save(Turno.new(medico, paciente, fecha_sistema))
    turnos = repo_turnos.buscar_superposiciones(Turno.new(medico, paciente, fecha_sistema))
    post "/turnos/#{turnos[0].id}/asistencia", {}, headers_autorizacion
    expect(last_response.status).to eq 200
    expect(repo_turnos.find(turnos[0].id).estado.id).to be EstadoTurnoID::ASISTIDO
  end

  it 'busco los proximos turnos de un paciente' do
    paciente = crear_paciente
    turno_futuro = Turno.new(medico, paciente, fecha_sistema + 1)
    turno_asistido = Turno.new(medico, paciente, fecha_sistema - 1)
    repo_turnos.save(turno_futuro)
    turno_asistido.confirmar_asistencia(proveedor_fecha_fija)
    repo_turnos.save(turno_asistido)
    get "/turnos_pendientes/#{paciente.username}/0/3", { id_paciente: paciente.id }.to_json, headers_autorizacion
    expect(last_response.status).to eq 200
    expect(repo_turnos.find(turno_asistido.id).estado.id).to be EstadoTurnoID::ASISTIDO
  end

  it 'registro la inasistencia de un paciente' do
    paciente = crear_paciente
    repo_turnos.save(Turno.new(medico, paciente, fecha_sistema - 1))
    turnos = repo_turnos.buscar_superposiciones(Turno.new(medico, paciente, fecha_sistema - 1))
    post "/turnos/#{turnos[0].id}/inasistencia", {}, headers_autorizacion
    expect(last_response.status).to eq 200
    expect(repo_turnos.find(turnos[0].id).estado.id).to be EstadoTurnoID::AUSENTE
  end

  describe 'cancelacion de turnos exitosa' do
    def ejecutar_cancelacion_exitosa(turno_a_cancelar)
      guardar_turno(turno_a_cancelar)
      realizar_peticion_cancelacion(turno_a_cancelar)
      verificar_respuesta_exitosa
      verificar_turno_cancelado(turno_a_cancelar)
      JSON.parse(last_response.body)['mensaje']
    end

    def guardar_turno(turno)
      repo_turnos.save(turno)
    end

    def realizar_peticion_cancelacion(turno)
      post "/turnos/#{turno.id}/cancelar", {}, headers_autorizacion
      expect(last_response.status).to eq 200
    end

    def verificar_respuesta_exitosa
      expect(last_response.status).to eq(200)
    end

    def verificar_turno_cancelado(turno)
      turno_actualizado = repo_turnos.find(turno.id)
      expect(turno_actualizado.estado.id).to be(EstadoTurnoID::CANCELADO)
    end

    it 'paciente cancela turno con mas de 24 horas y este sigue disponible' do
      turno_con_mas_de_24_horas = Turno.new(medico, paciente, fecha_sistema + 25)
      respuesta = ejecutar_cancelacion_exitosa(turno_con_mas_de_24_horas)
      expect(respuesta).to eq('Turno cancelado.')
    end

    it 'paciente cancela turno del dia siguiente con menos de 24 horas y este sigue disponible' do
      turno_con_menos_de_24_horas_del_dia_siguiente = Turno.new(medico, paciente, fecha_sistema + 22)
      respuesta = ejecutar_cancelacion_exitosa(turno_con_menos_de_24_horas_del_dia_siguiente)
      expect(respuesta).to eq('Turno cancelado. Se considera inasistencia.')
    end

    it 'paciente cancela turno futuro el mismo dia y este no sigue disponible' do
      turno_futuro_mismo_dia = Turno.new(medico, paciente, fecha_sistema + 2)
      respuesta = ejecutar_cancelacion_exitosa(turno_futuro_mismo_dia)
      expect(respuesta).to eq('Turno cancelado. Se considera inasistencia.')
    end
  end

  describe 'cancelacion de turnos fallida' do
    it 'paciente no puede cancelar un turno pasado' do
      turno_pasado = Turno.new(medico, paciente, fecha_sistema - 2)
      repo_turnos.save(turno_pasado)
      post "/turnos/#{turno_pasado.id}/cancelar", {}.to_json, headers_autorizacion
      expect(last_response.status).to eq 409
    end
  end

  describe 'historial de turnos' do
    it 'se hace consulta de todos los turnos de un paciente' do
      paciente = crear_paciente
      turno_futuro = Turno.new(medico, paciente, fecha_sistema)
      turno_pasado1 = Turno.new(medico, paciente, fecha_sistema - 2)
      turno_pasado1.confirmar_asistencia(proveedor_fecha_fija)

      turno_pasado2 = Turno.new(medico, paciente, fecha_sistema - 1)
      turno_pasado2.confirmar_ausencia(proveedor_fecha_fija)

      repo_turnos.save(turno_futuro)
      repo_turnos.save(turno_pasado1)
      repo_turnos.save(turno_pasado2)

      get "/historial_turnos/#{paciente.username}", {}.to_json, headers_autorizacion

      expect(last_response.status).to eq 200
      turnos = JSON.parse(last_response.body)
      expect(turnos.map do |t|
        FechaHorario.new(t['fecha'])
      end).to match_array([fecha_sistema - 1, fecha_sistema - 2])
    end
  end

  describe 'penalizacion de pacientes' do
    it 'penaliza a un paciente con 1 inasistencia y 9 asistencias' do
      paciente = crear_paciente
      repo_reputaciones.save(Reputacion.new(paciente.id, 0, 0, 0))
      (1..9).each do |i|
        repo_turnos.save(Turno.new(medico, paciente, fecha_sistema - i))
        turnos = repo_turnos.buscar_superposiciones(Turno.new(medico, paciente, fecha_sistema - i))
        post "/turnos/#{turnos[0].id}/asistencia", {}, headers_autorizacion
        expect(last_response.status).to eq 200
      end

      repo_turnos.save(Turno.new(medico, paciente, fecha_sistema - 10))
      turnos = repo_turnos.buscar_superposiciones(Turno.new(medico, paciente, fecha_sistema - 10))
      post "/turnos/#{turnos[0].id}/inasistencia", {}, headers_autorizacion
      expect(last_response.status).to eq 200
      expect(sistema.consultar_reputacion(paciente.username)).to eq(-1)
    end

    it 'paciente penalizado no puede tener mas de un turno pendiente' do
      paciente = crear_paciente
      repo_reputaciones.save(Reputacion.new(paciente.id, 0, 0, 0))

      repo_turnos.save(Turno.new(medico, paciente, fecha_sistema - 10))
      turnos = repo_turnos.buscar_superposiciones(Turno.new(medico, paciente, fecha_sistema - 10))
      post "/turnos/#{turnos[0].id}/inasistencia", {}, headers_autorizacion

      post '/reservar', { id_medico: medico.id, fecha: '08/10/2025 10:00', username: paciente.username }.to_json,
           headers_autorizacion

      post '/reservar', { id_medico: medico.id, fecha: '08/10/2025 11:00', username: paciente.username }.to_json,
           headers_autorizacion
      expect(last_response.status).to eq 408
    end
  end

  describe 'turnos asignados a un medico' do
    it 'busca turnos asignados a un medico' do
      paciente = crear_paciente
      fecha_turno = fecha_sistema + 1
      turno = Turno.new(medico, paciente, fecha_turno)
      repo_turnos.save(turno)

      get "/turnos?medico_id=#{medico.id}", {}.to_json, headers_autorizacion
      expect(last_response.status).to eq 200
      turnos = JSON.parse(last_response.body)
      expect(turnos.size).to eq 1
      expect(turnos[0]['id_turno']).to eq turno.id
    end

    it 'busca turnos asignados a un medico sin turnos' do
      get "/turnos?medico_id=#{medico.id}", {}, headers_autorizacion
      expect(last_response.status).to eq 200
      turnos = JSON.parse(last_response.body)
      expect(turnos).to be_empty
    end

    it 'al buscar turnos asignados a un medico se lanza un error' do
      allow(app.settings.sistema).to receive(:buscar_turnos_asignados_por_medico).and_raise(StandardError, 'Ocurrió un error inesperado')

      get "/turnos?medico_id=#{medico.id}", {}, headers_autorizacion
      expect(last_response.status).to eq 500
      expect(JSON.parse(last_response.body)['error']).to eq 'Error: Ocurrió un error inesperado'
    end
  end

  describe 'Funcioanlidades para entorno de test' do
    describe 'Proveedor de feriados' do
      it 'cambia el proveedor de feriados a FeriadosNoLaborables' do
        feriado = Fecha.new('01/01/2025')
        stubear_proveedor_feriados_no_labroables
        feriados = consultar_feriados
        expect(feriados['feriados'][0]).to eq(feriado.to_s)
      end

      it 'cambia el proveedor de feriados a FeriadosMock' do
        feriado = Fecha.new('02/02/2025')
        setear_feriados([feriado.to_s])
        feriados = consultar_feriados
        expect(feriados['feriados'][0]).to eq(feriado.to_s)
      end
    end
  end
end

def crear_paciente(nombre: 'juan', dni: 21_221, email: 'juan@test.com')
  paciente = Paciente.new(nombre,  dni, email, nil, 'juanusername')
  repo_pacientes.save(paciente)
  repo_reputaciones.save(Reputacion.new(paciente.id, 0, 0, 0))
  paciente
end

def crear_medico(nombre: 'Juan Matrix', especialidad: 'Clinico', duracion: 15, matricula: '102_203', trabaja_feriados: false)
  repo_especialidades.save(Especialidad.new(especialidad, duracion))
  repo_medicos.save(Medico.new(nombre, repo_especialidades.buscar_por_nombre(especialidad), matricula, trabaja_feriados))
  repo_medicos.buscar_por_matricula(matricula)
end
