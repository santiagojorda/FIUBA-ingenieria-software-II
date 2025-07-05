require_relative './model/correo'
require 'sinatra'

set :default_content_type, :json
correo = Correo.new(Almacen.new)

before do
  if !request.body.nil? && request.body.size.positive?
    request.body.rewind
    @params = JSON.parse(request.body.read)
  end
end

get '/cotizacion' do
  id_envio = correo.crear_envio
  { id: id_envio }.to_json
end

get '/cotizacion/:id/checkout' do
  id = params['id']
  begin
    factura = correo.checkout(id)
    { costo: factura.importe }.to_json
  rescue StandardError => e
    status 400
    { descripcion: e.message }.to_json
  end
end

post '/cotizacion/:id' do
  id = params['id']
  paquete = params['paquete']
  begin
    correo.agregar_paquete(id, paquete)
    status 200
  rescue StandardError => e
    status 400
    { descripcion: e.message }.to_json
  end
end
