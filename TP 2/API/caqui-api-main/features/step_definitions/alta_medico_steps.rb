Cuando(
  'registro un medico con la informacion: {string} como nombre {string} como especialidad ' \
  '{string} como matricula y {string} para trabaja feriados'
) do |nombre, especialidad_str, matricula, trabaja_feriados_str|
  trabaja_feriados = trabaja_feriados_str.downcase == 'true'

  post '/especialidades', { nombre: especialidad_str, duracion: 15 }.to_json, { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => ENV['AUTH_TOKEN'] }
  expect(last_response.status).to eq 201

  post '/medicos', { nombre:, especialidad: especialidad_str, matricula:, trabaja_feriados: }.to_json,
       { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => ENV['AUTH_TOKEN'] }
end

Entonces('se registro exitosamente') do
  expect(last_response.status).to eq 201
end

Entonces('el medico tiene un id asignado') do
  expect(JSON.parse(last_response.body)['id']).to be_a(Integer)
end
