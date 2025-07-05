Dado('que existe un medico') do
  post '/especialidades', { nombre: 'infectologia', duracion: 30 }.to_json, { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => ENV['AUTH_TOKEN'] }

  post '/medicos', { nombre: 'Dr. House', especialidad: 'infectologia', matricula: '1234', trabaja_feriados: false }.to_json,
       { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => ENV['AUTH_TOKEN'] }
  expect(last_response.status).to eq 201
  @medico = JSON.parse(last_response.body)
end

Y('ese medico tiene {string} turnos reservados') do |cantidad_turnos|
  get "/turnos/#{@medico['id']}/0/#{cantidad_turnos}", {}, { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => ENV['AUTH_TOKEN'] }
  expect(last_response.status).to eq 200
  @turnos_disponibles = JSON.parse(last_response.body)

  post '/paciente', { nombre: 'Laura', dni: 456_432, email: 'laura@mail.com', username: 'laura' }.to_json, { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => ENV['AUTH_TOKEN'] }
  expect(last_response.status).to eq 201
  @paciente = JSON.parse(last_response.body)

  @turnos_disponibles.first(cantidad_turnos.to_i).each do |turno|
    post '/reservar', { id_medico: @medico['id'], username: @paciente['username'], fecha: turno['fecha'] }.to_json,
         { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => ENV['AUTH_TOKEN'] }
    expect(last_response.status).to eq 201
  end
end

Cuando('se consulta los turnos pendientes del medico') do
  get "/turnos?medico_id=#{@medico['id']}", {}, { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => ENV['AUTH_TOKEN'] }
  expect(last_response.status).to eq 200
  @turnos_pendientes = JSON.parse(last_response.body)
end

Entonces('se muestra una lista con id_turno, fecha, hora, nombre de paciente') do
  expect(@turnos_pendientes).not_to be_empty
  @turnos_pendientes.each do |turno|
    expect(turno).to include(
      'id_turno' => a_kind_of(Integer),
      'fecha' => a_kind_of(String),
      'nombre_paciente' => a_kind_of(String)
    )
  end
end

Dado('ese medico no tiene turnos reservados') do
end

Entonces('se muestra una lista vacia') do
  expect(@turnos_pendientes).to be_empty
end
