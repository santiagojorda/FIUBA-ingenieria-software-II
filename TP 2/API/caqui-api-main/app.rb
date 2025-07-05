require 'English'
require 'sinatra'
require 'sinatra/json'
require 'sequel'
require 'sinatra/custom_logger'
require_relative './config/configuration'
require_relative './lib/version'
require 'uuid'
require 'dotenv/load'
require_relative 'config/middleware'

Dir[File.join(__dir__, 'dominio', '**', '*.rb')].sort.each { |file| require file }
Dir[File.join(__dir__, 'persistencia', '**', '*.rb')].sort.each { |file| require file }
Dir[File.join(__dir__, 'utilidades', '**', '*.rb')].sort.each { |file| require file }
Dir[File.join(__dir__, 'proveedores', '**', '*.rb')].sort.each { |file| require file }
Dir[File.join(__dir__, 'gestores', '**', '*.rb')].sort.each { |file| require file }

configure do
  customer_logger = Configuration.logger
  DB = Configuration.db # rubocop:disable  Lint/ConstantDefinitionInBlock
  DB.loggers << customer_logger
  set :logger, customer_logger
  set :default_content_type, :json
  set :environment, ENV['APP_MODE'].to_sym

  proveedor_fecha = ProveedorFechaReal.new
  proveedor_feriados = ProveedorFeriadosNoLaborables.new(proveedor_fecha.ahora.anio)

  set :sistema,
      Sistema::Builder.new
                      .con_repositorio_especialidades(RepositorioEspecialidades.new)
                      .con_repositorio_medicos(RepositorioMedicos.new)
                      .con_repositorio_pacientes(RepositorioPacientes.new)
                      .con_repositorio_turnos(RepositorioTurnos.new)
                      .con_proveedor_fecha(proveedor_fecha)
                      .con_proveedor_feriados(proveedor_feriados)
                      .con_repositorio_reputaciones(RepositorioReputaciones.new)
                      .build
  use LogMiddleware
  customer_logger.info('Iniciando sistema...')
end

before do
  pass if request.path == '/version'

  auth_header = request.env['HTTP_AUTHORIZATION']
  if auth_header != ENV['AUTH_TOKEN']
    halt 401
    return
  end
  str_log = "llega: #{request.request_method} #{request.path} - parametros: #{params.inspect}"
  status 200
  if !request.body.nil? && request.body.size.positive?
    request.body.rewind
    @params = JSON.parse(request.body.read, symbolize_names: true)
    str_log += " body: #{@params.inspect}"
  end
  logger.info(str_log)
end

after do
  pass if request.path == '/version'
  response_body = response.body.empty? ? 'vacía' : response.body.join
  logger.info("sale: #{request.request_method} #{request.path} - estado: #{response.status} - respuesta: #{response_body}")
end

def sistema
  settings.sistema
end

post '/proveedor/fecha' do
  unless ENV['TEST_ENV']
    status 403
    json({ mensaje: 'funcion-authorizada-solo-para-test' })
    return
  end
  fecha_horario_str = @params[:fecha_horario]

  if fecha_horario_str.nil?
    sistema.proveedor_fecha = ProveedorFechaReal.new
  else
    fecha_horario = FechaHorario.new(fecha_horario_str)
    sistema.proveedor_fecha = ProveedorFechaFija.new(fecha_horario)
  end
rescue StandardError => e
  status 400
  json({ error: e.message })
end

get '/proveedor/fecha' do
  unless ENV['TEST_ENV']
    status 403
    json({ mensaje: 'funcion-authorizada-solo-para-test' })
    return
  end
  status 200
  json({ fecha_horario: sistema.proveedor_fecha.ahora.to_s })
end

post '/proveedor/feriados' do
  unless ENV['TEST_ENV'] == 'test'
    status 403
    json({ mensaje: 'funcion-authorizada-solo-para-test' })
    return
  end
  fecha_feriados_str = @params[:fecha_feriados]

  sistema.proveedor_feriados = if fecha_feriados_str.nil?
                                 ProveedorFeriadosNoLaborables.new(sistema.proveedor_fecha.ahora.anio)
                               else
                                 ProveedorFeriadosMock.new(fecha_feriados_str)
                               end
rescue StandardError => e
  status 400
  json({ error: e.message })
end

get '/proveedor/feriados' do
  unless ENV['TEST_ENV'] == 'test'
    status 403
    json({ mensaje: 'funcion-authorizada-solo-para-test' })
    return
  end
  status 200
  json({ feriados: sistema.proveedor_feriados.feriados })
rescue StandardError => e
  status 400
  json({ error: e.message })
end

get '/version' do
  json({ version: Version.current })
end

post '/reset' do
  status 200
end

post '/paciente' do
  paciente = sistema.crear_paciente(@params[:nombre], @params[:dni].to_i, @params[:email], @params[:username])
  status 201
  { id: paciente.id, nombre: paciente.nombre, dni: paciente.dni, email: paciente.email, username: paciente.username }.to_json
rescue StandardError => e
  status 400
  json({ error: e.message })
end

post '/especialidades' do
  especialidad = sistema.crear_especialidad(@params[:nombre], @params[:duracion].to_i)
  status 201
  { id: especialidad.id, nombre: especialidad.nombre, duracion: especialidad.tiempo_atencion }.to_json
end

post '/medicos' do
  medico = sistema.crear_medico(@params[:nombre], @params[:especialidad], @params[:matricula], @params[:trabaja_feriados])
  status 201
  return { id: medico.id, nombre: medico.nombre, especialidad: medico.especialidad.nombre, matricula: medico.matricula, trabaja_feriados: medico.trabaja_feriados }.to_json
end

get '/medicos/:id_medico' do
  id_medico = @params[:id_medico].to_i
  medico = sistema.buscar_medico_por_id(id_medico)
  if medico.nil?
    status 404
    return { error: 'Medico no encontrado' }.to_json
  end
  status 200
  json({ id: medico.id, nombre: medico.nombre, especialidad: medico.especialidad.nombre, matricula: medico.matricula, trabaja_feriados: medico.trabaja_feriados })
end

get '/turnos/:id_medico/:inicio/:fin' do
  id_medico = @params[:id_medico].to_i
  inicio = @params[:inicio].to_i
  fin = @params[:fin].to_i
  turnos = sistema.turnos_disponibles(id_medico, inicio, fin)
  respuesta = turnos.map do |turno|
    {
      fecha: turno
    }
  end
  status 200
  json(respuesta)
end

get '/turnos_pendientes/:paciente_username_telegram/:inicio/:fin' do
  username_paciente = @params[:paciente_username_telegram]
  inicio = @params[:inicio].to_i
  fin = @params[:fin].to_i
  turnos = sistema.buscar_turnos_pendientes_por_paciente(username_paciente, inicio, fin)
  respuesta = turnos.map do |turno|
    {
      id_turno: turno.id,
      fecha: turno.fecha,
      nombre_medico: turno.medico.nombre,
      especialidad: turno.medico.especialidad.nombre,
      estado: turno.estado.id
    }
  end
  status 200
  json(respuesta)
rescue StandardError => e
  status 500
  json({ error: "Error #{e.message}" })
end

post '/reservar' do
  fecha_turno = FechaHorario.new(@params[:fecha])

  penalizacion = sistema.consultar_reputacion(@params[:username])
  turnos_pendientes = sistema.buscar_turnos_pendientes_por_paciente(@params[:username], 0, 2)
  if turnos_pendientes.length >= 1 && penalizacion == -1
    status 408
    return
  end
  turno_reservado = sistema.reservar_turno(@params[:id_medico].to_i, @params[:username], fecha_turno)
  status 201
  json(id_turno: turno_reservado.id)
rescue StandardError => e
  status 409
  json({ error: e.message })
end

post '/turnos/:id_turno/asistencia' do
  sistema.confirmar_asistencia_turno(@params[:id_turno].to_i)
  sistema.aumentar_asistencias(@params[:id_turno].to_i)
  status 200
rescue StandardError => e
  status 409
  json({ error: e.message })
end

post '/turnos/:id_turno/inasistencia' do
  sistema.aumentar_inasistencias(@params[:id_turno].to_i)
  sistema.confirmar_ausencia_turno(@params[:id_turno].to_i)
  status 200
rescue StandardError => e
  status 409
  json({ error: e.message })
end

get '/historial_turnos/:username_paciente' do
  username_paciente = @params[:username_paciente]
  historial_turnos = sistema.consultar_historial_turnos(username_paciente)
  respuesta = historial_turnos.map do |turno|
    {
      id: turno.id,
      fecha: turno.fecha.to_s,
      especialidad: turno.medico.especialidad.nombre,
      nombre_medico: turno.medico.nombre,
      estado: turno.estado.to_s
    }
  end
  status 200
  json(respuesta)
rescue StandardError => e
  status 500
  json({ error: "Error #{e.message}" })
end

post '/turnos/:id_turno/cancelar' do
  id_turno = @params['id_turno'].to_i
  mensaje = sistema.cancelar_turno(id_turno)
  sistema.aumentar_cancelaciones(id_turno)
  status 200
  json({ mensaje: })
rescue StandardError => e
  status 409
  json({ error: e.message })
end

get '/turnos' do
  medico_id = @params[:medico_id].to_i
  turnos = sistema.buscar_turnos_asignados_por_medico(medico_id)
  respuesta = turnos.map do |turno|
    {
      id_turno: turno.id,
      fecha: turno.fecha,
      nombre_paciente: turno.paciente.nombre
    }
  end
  status 200
  json(respuesta)
rescue StandardError => e
  status 500
  json({ error: "Error: #{e.message}" })
end
