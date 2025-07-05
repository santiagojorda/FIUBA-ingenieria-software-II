ENV['APP_ENV'] = 'test'
require 'spec_helper'
require_relative '../app_web'
require 'rack/test'

describe 'Alquiler' do
	include Rack::Test::Methods

	def app
		Sinatra::Application
	end

	it 'sin entrada muestra error' do
		get '/alquiler?tipo=&datos=&cuit='
		expect(last_response.status).to eq 400
	end

	it 'alquiler por hora se aplica descuento perfectamente' do
		get '/alquiler?tipo=h&datos=3&cuit=26112223336"'
		expect(last_response).to be_ok
		expect(last_response.body).to eq({importe: 282.1, ganancia: 126.9}.to_json)
	end

	it 'alquiler por hora no se aplica descuento perfectamente' do
		get '/alquiler?tipo=h&datos=3&cuit=20112223336"'
		expect(last_response).to be_ok
		expect(last_response.body).to eq({importe: 297.0, ganancia: 133.6}.to_json)
	end

  it 'alquiler por dia se aplica descuento perfectamente' do
		get '/alquiler?tipo=d&datos=21&cuit=26112223336"'
		expect(last_response).to be_ok
		expect(last_response.body).to eq({importe: 39919.9, ganancia: 17963.9}.to_json)
	end

	it 'alquiler por dia no se aplica descuento perfectamente' do
		get '/alquiler?tipo=d&datos=21&cuit=20112223336"'
		expect(last_response).to be_ok
		expect(last_response.body).to eq({importe: 42021.0, ganancia: 18909.4}.to_json)
	end

  it 'alquiler por kilometros se aplica descuento perfectamente' do
		get '/alquiler?tipo=k&datos=5&cuit=26112223336"'
		expect(last_response).to be_ok
		expect(last_response.body).to eq({importe: 142.5, ganancia: 64.1}.to_json)
	end

	it 'alquiler por kilometros no se aplica descuento perfectamente' do
		get '/alquiler?tipo=k&datos=5&cuit=20112223336"'
		expect(last_response).to be_ok
		expect(last_response.body).to eq({importe: 150.0, ganancia: 67.5}.to_json)
	end

  it 'alquiler por kilometros no ingresa el parametro datos' do
		get '/alquiler?tipo=k&datos=0&cuit=20112223336"'
		expect(last_response).to be_ok
		expect(last_response.body).to eq({importe: 0.0, ganancia: 0.0}.to_json)
	end

  it 'alquiler por dia no ingresa el parametro datos' do
		get '/alquiler?tipo=d&datos=0&cuit=20112223336"'
		expect(last_response).to be_ok
		expect(last_response.body).to eq({importe: 0.0, ganancia: 0.0}.to_json)
	end

  it 'alquiler por hora no ingresa el parametro datos' do
		get '/alquiler?tipo=h&datos=0&cuit=20112223336"'
		expect(last_response).to be_ok
		expect(last_response.body).to eq({importe: 0.0, ganancia: 0.0}.to_json)
	end

  it 'alquiler por kilometros no ingresa el parametro tipo valido' do
		get '/alquiler?tipo=w&datos=0&cuit=20112223336"'
		expect(last_response.status).to eq 400
	end
end