Dado('que el paciente {string} está registrado') do |nombre_paciente|
  @telegram_username = "#{nombre_paciente}supreme"
  post '/paciente', { nombre: nombre_paciente, dni: 232_432, email: 'mail@bu.com', username: @telegram_username }.to_json, { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => ENV['AUTH_TOKEN'] }
  expect(last_response.status).to eq 201
  @paciente = JSON.parse(last_response.body)
end

Dado('que el paciente {string} tiene turnos reservados') do |_nombre_paciente|
  post '/especialidades', { nombre: 'traumatologia', duracion: 30 }.to_json, { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => ENV['AUTH_TOKEN'] }

  post '/medicos', { nombre: 'Dr. Smith', especialidad: 'traumatologia', matricula: '1234', trabaja_feriados: false }.to_json,
       { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => ENV['AUTH_TOKEN'] }
  expect(last_response.status).to eq 201
  @medico = JSON.parse(last_response.body)

  get "/turnos/#{@medico['id']}/0/2", {}, { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => ENV['AUTH_TOKEN'] }
  expect(last_response.status).to eq 200

  @turnos = JSON.parse(last_response.body)
  primer_turno = @turnos.first['fecha']

  post '/reservar', { id_medico: @medico['id'], username: @telegram_username, fecha: primer_turno }.to_json,
       { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => ENV['AUTH_TOKEN'] }
  expect(last_response.status).to eq 201
end

Cuando('el paciente consulta los turnos pendientes') do
  get "/turnos_pendientes/#{@telegram_username}/0/10", {}, { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => ENV['AUTH_TOKEN'] }
  expect(last_response.status).to eq 200
  @turnos_pendientes = JSON.parse(last_response.body)
end

Entonces('el sistema muestra una lista con id_turno, fecha, hora, especialidad y nombre_medico') do
  @turnos_pendientes.each do |turno|
    expect(turno).to include(
      'id_turno' => a_kind_of(Integer),
      'fecha' => a_kind_of(String),
      'nombre_medico' => a_kind_of(String),
      'especialidad' => a_kind_of(String)
    )
  end
end

Dado('que el paciente {string} no tiene turnos reservados') do |_nombre_paciente|
  post '/especialidades', { nombre: 'traumatologia', duracion: 30 }.to_json, { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => ENV['AUTH_TOKEN'] }

  post '/medicos', { nombre: 'Dr. bob esponja', especialidad: 'traumatologia', matricula: '1234', trabaja_feriados: false }.to_json,
       { 'CONTENT_TYPE' => 'application/json',  'HTTP_AUTHORIZATION' => ENV['AUTH_TOKEN'] }
  expect(last_response.status).to eq 201
  @medico = JSON.parse(last_response.body)
end

Entonces('el sistema muestra que no hay turnos') do
  expect(@turnos_pendientes).to eq([]).or eq({})
end
