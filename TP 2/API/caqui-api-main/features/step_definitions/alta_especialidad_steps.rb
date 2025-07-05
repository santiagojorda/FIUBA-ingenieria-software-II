def headers_autorizacion
  { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => ENV['AUTH_TOKEN'] }
end

When(/^envía una solicitud para crear una especialidad con nombre "(.*)" y duración de "(.*)" minutos$/) do |nombre, duracion|
  post '/especialidades', { nombre:, duracion: duracion.to_i }.to_json, headers_autorizacion

  @response = last_response
end

Then('el sistema crea la especialidad') do
  expect(@response.status).to eq 201
end

And 'adjunta el id de la especialidad creada' do
  json = JSON.parse(@response.body)
  expect(json['id']).to be_a(Integer)
end
