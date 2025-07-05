require_relative './model/inversor'
require 'sinatra'

get '/' do
  'inversor web app'
end

get '/invertir' do
  texto = params['texto']
  return halt 400, 'entrada invalida' if texto.nil? || texto.empty?

  Inversor.new.invertir(texto)
end
