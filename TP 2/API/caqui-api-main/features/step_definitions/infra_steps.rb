Cuando('pido get version') do
  get '/version', {}.to_json, headers_autorizacion
end

Entonces('obtengo la version de la api') do
  expect(last_response.status).to be == 200
  expect(JSON.parse(last_response.body)['version']).to eq Version.current
end

Entonces('la respuesta es de tipo json') do
  expect(last_response.headers['Content-Type']).to eq 'application/json'
end
