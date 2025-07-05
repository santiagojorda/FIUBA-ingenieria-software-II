When(/^que no estoy autenticado$/) do
  # no hay nada q hacer
end

When(/^quiero registrarme$/) do
  post '/paciente', { nombre: 'fran', dni: 412_112, email: 'fran@memo.com', username: 'FranCABJ12' }.to_json, { 'CONTENT_TYPE' => 'application/json' }
  @response = last_response
end

When(/^obtengo un error por no estar autorizado\.$/) do
  expect(@response.status).to eq(401)
end
