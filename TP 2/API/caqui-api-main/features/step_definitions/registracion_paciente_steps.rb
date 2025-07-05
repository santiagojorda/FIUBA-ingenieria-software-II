Dado(/^que el paciente ingresa el nombre "([^"]*)", el dni "([^"]*)" y el mail "([^"]*)"$/) do |nombre, dni, email|
  @nombre = nombre
  @dni = dni.to_i
  @email = email
end

Cuando('se registra') do
  post '/paciente', { nombre: @nombre, dni: @dni, email: @email, username: '' }.to_json, headers_autorizacion
  @response = last_response
end

Entonces('el sistema registra al paciente de forma exitosa') do
  expect(@response.status).to eq 201
  json = JSON.parse(@response.body)
  expect(json['id']).to be_a(Integer)
  expect(json['nombre']).to eq @nombre
  expect(json['dni']).to eq @dni
  expect(json['email']).to eq @email
end
