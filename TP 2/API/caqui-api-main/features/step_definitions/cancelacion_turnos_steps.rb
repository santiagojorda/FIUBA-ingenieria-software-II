def crear_paciente
  nombre_paciente = 'Juan Pérez'
  @telegram_username = "#{nombre_paciente}supreme"
  dni = 232_432
  post '/paciente',
       { nombre: nombre_paciente, dni:, email: 'mail@bu.com', username: @telegram_username }.to_json,
       headers_autorizacion
  expect(last_response.status).to eq 201
  repo_pacientes = RepositorioPacientes.new
  repo_pacientes.buscar_por_dni(dni)
end

def crear_especialidad(nombre_especialidad)
  post '/especialidades', { nombre: nombre_especialidad, duracion: 30 }.to_json, headers_autorizacion
  expect(last_response.status).to eq 201
end

def consultar_turnos(_medico_id)
  get "/turnos/#{@medico.id}/0/15", {}.to_json, headers_autorizacion
  expect(last_response.status).to eq 200
  JSON.parse(last_response.body)
end

def encontrar_fecha_turno_por_medico(medico, fecha_objectivo)
  lista_de_turnos = consultar_turnos(medico.id)
  lista_de_turnos.find do |turno|
    turno['fecha'] == fecha_objectivo.to_s
  end
end

def crear_medico(trabaja_feriados: false)
  nombre_especialidad = 'traumatologia'
  matricula = 1234
  crear_especialidad(nombre_especialidad)
  post '/medicos', { nombre: 'Dr. Smith', especialidad: nombre_especialidad, matricula:, trabaja_feriados: }.to_json,
       headers_autorizacion
  expect(last_response.status).to eq 201
  repo_medicos = RepositorioMedicos.new
  repo_medicos.buscar_por_matricula(matricula)
end

def crear_turno(paciente, medico, fecha)
  @turno = Turno.new(medico, paciente, fecha)
  RepositorioTurnos.new.save(@turno)
  expect(@turno.id).to be_a(Integer)
  @turno
end

def post_proveedor_fecha(fecha: nil, headers: headers_autorizacion)
  body = {}
  body = { fecha_horario: fecha.to_s } unless fecha.nil?
  post '/proveedor/fecha', body.to_json, headers
  expect(last_response.status).to eq 200
end

def get_proveedor_fecha(headers: headers_autorizacion)
  get '/proveedor/fecha', {}, headers
  expect(last_response.status).to eq 200
end

def crear_sistema_con_fecha_fija(fecha)
  post_proveedor_fecha(fecha:)
end

Dado('que soy un paciente') do
  @paciente = crear_paciente
end

Dado('hoy y mañana son dias habiles, no feriados') do
  @fecha_hoy = FechaHorario.new('10/06/2025 12:00')
  crear_sistema_con_fecha_fija(@fecha_hoy)
end

Dado('tengo un turno pendiente agendado para mañana dentro de más de 24 horas') do
  @medico = crear_medico
  fecha_turno_mas_24_horas = @fecha_hoy + 26
  @fecha_turno = fecha_turno_mas_24_horas
  @turno = crear_turno(@paciente, @medico, fecha_turno_mas_24_horas)
end

Cuando('cancelo dicho turno') do
  post "/turnos/#{@turno.id}/cancelar", {}, headers_autorizacion
end

Entonces('el turno se registra como cancelado') do
  turno = RepositorioTurnos.new.find(@turno.id)
  expect(turno.estado.id).to eq EstadoTurnoID::CANCELADO
end

Entonces('Y la cancelación no se considera inasistencia') do
  turno = RepositorioTurnos.new.find(@turno.id)
  expect(turno.estado.id).to eq EstadoTurnoID::CANCELADO
end

Entonces('se notifica al paciente con el mensaje: {string}') do |mensaje|
  respuesta_parseada = JSON.parse(last_response.body)
  expect(respuesta_parseada['mensaje']).to eq mensaje
end

Entonces('el horario del turno SI queda disponible.') do
  fecha_turno_encontrada = encontrar_fecha_turno_por_medico(@medico, @fecha_turno)
  expect(fecha_turno_encontrada).to_not be_nil
end

Dado('tengo un turno pendiente agendado para mañana dentro de menos de 24 horas') do
  @medico = crear_medico
  fecha_turno_menos_24_horas = @fecha_hoy + 22
  @fecha_turno = fecha_turno_menos_24_horas
  crear_turno(@paciente, @medico, fecha_turno_menos_24_horas)
end

Entonces('el horario del turno NO queda disponible.') do
  fecha_turno_encontrada = encontrar_fecha_turno_por_medico(@medico, @fecha_turno)
  expect(fecha_turno_encontrada).to be_nil
end

Dado('hoy es un dia habil y no es feriado') do
  @fecha_hoy = FechaHorario.new('10/06/2025 11:00')
  crear_sistema_con_fecha_fija(@fecha_hoy)
end

Dado('tengo un turno pendiente agendado para el mismo dia') do
  @medico = crear_medico
  fecha_turno_mismo_dia = @fecha_hoy + 2
  @fecha_turno = fecha_turno_mismo_dia
  @turno = crear_turno(@paciente, @medico, fecha_turno_mismo_dia)
end

Dado('tengo un turno agendado para hoy pero este ya pasó') do
  @medico = crear_medico
  fecha_turno_pasado = @fecha_hoy - 10
  @fecha_turno = fecha_turno_pasado
  @turno = crear_turno(@paciente, @medico, fecha_turno_pasado)
end

Entonces('el sistema no permite la cancelación del turno.') do
  expect(last_response.status).to eq 409
end
