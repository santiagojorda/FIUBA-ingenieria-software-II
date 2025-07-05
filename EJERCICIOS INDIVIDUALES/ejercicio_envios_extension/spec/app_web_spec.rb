ENV['APP_ENV'] = 'test'
require 'spec_helper'
require_relative '../app_web'
require 'rack/test'
require 'debug'

describe 'App web' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def enviar(paquetes)
    # crear envio
    get '/cotizacion'
    respuesta_json = JSON.parse(last_response.body)
    expect(last_response.status).to eq 200
    respuesta = Respuesta.new
    respuesta.id = respuesta_json['id']
    paquetes.each do |paquete|
      # agregar paquete al envio
      post "/cotizacion/#{respuesta.id}", { paquete: paquete }.to_json, { "CONTENT_TYPE" => "application/json" }
      expect(last_response.status).to eq 200
    end
    # cotizar envio
    get "/cotizacion/#{respuesta.id}/checkout"
    respuesta_json = JSON.parse(last_response.body)
    if last_response.status == 200
      expect(last_response.status).to eq 200
      respuesta.costo = respuesta_json['costo'].to_f
    else
      respuesta.descripcion = respuesta_json['descripcion']
    end
    respuesta.status = last_response.status
    respuesta
  end

  it 'c1: envio con un paquete cuadrado' do
    resultado = enviar(['C'])
    expect(resultado.status).to eq 200
    expect(resultado.costo).to eq 2.2
  end

  it 'c2: envio con un 6 paquetes cuadrados' do
    resultado = enviar(['C','C','C','C','C','C'])
    expect(resultado.status).to eq 200
    expect(resultado.costo).to eq 9
  end

  it 'r1: envio con un paquete redondo' do
    resultado = enviar(['R'])
    expect(resultado.status).to eq 200
    expect(resultado.costo).to eq 4.4
  end

  it 't1: envio con un paquete triangular' do
    resultado = enviar(['T'])
    expect(resultado.status).to eq 200
    expect(resultado.costo).to eq 3.3
  end

  it 't2: envio con un paquete triangular y uno redondo cuesta' do
    resultado = enviar(['T','R'])
    expect(resultado.status).to eq 200
    expect(resultado.costo).to eq 7
  end

  it 'e1: envio vacio no es valido' do
    resultado = enviar([])
    expect(resultado.status).to eq 400
    expect(resultado.descripcion).to eq 'ENVIO_VACIO'
  end

  it 'e2: envio con dos paquetes triangulares y un paquete cuadradro ErrorEnvioNoValido' do
    resultado = enviar(['T','T','C'])
    expect(resultado.status).to eq 400
    expect(resultado.descripcion).to eq 'ENVIO_NO_VALIDO'
  end

  it 'e3: envio con mas de 8 paquetes no es valido' do
    resultado = enviar(['C','C','C','C','C','C','C','C','C'])
    expect(resultado.status).to eq 400
    expect(resultado.descripcion).to eq 'ENVIO_DEMASIADO_GRANDE'
  end

  it 'e4: envio inexistente' do
    post '/cotizacion/id-inexistente', { paquete: 'C' }.to_json, { "CONTENT_TYPE" => "application/json" }
    response_json = JSON.parse(last_response.body)
    expect(last_response.status).to eq 400
    expect(response_json['descripcion']).to eq 'ENVIO_INEXISTENTE'
  end

end

class Respuesta
  attr_accessor :id, :costo, :status, :descripcion
end
