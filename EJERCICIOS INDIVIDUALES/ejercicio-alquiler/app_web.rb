require_relative './model/alquiler'
require 'sinatra'

get '/' do
  'Alquiler web app'
end

get '/alquiler' do
  tipo = params['tipo']
  datos = params['datos'].to_i
  cuit = params['cuit']

  if tipo.nil? || tipo.empty? || datos.nil? || cuit.nil? || cuit.empty?
    return halt 400, {mensaje: 'parametros invalido'}.to_json
  end

  return halt 400, {mensaje: 'tipo de alquiler invalido'}.to_json unless %w[d h k].include?(tipo)

  resultado = Alquiler.new.calcular_alquiler(tipo, datos, cuit)
  resultado.to_json
end
