ENV['APP_ENV'] = 'test'
require 'spec_helper'
require_relative '../app_web'
require 'rack/test'

describe 'App web' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'sin entrada muestra error' do
    get '/invertir?texto='
    expect(last_response.status).to eq 400
  end

  it 'inverso de MiCasaLinda es mIcASAlINDA' do
    get '/invertir?texto=MiCasaLinda'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('mIcASAlINDA')
  end

  it 'inverso con numeros es igual' do
    get '/invertir?texto=1111'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('1111')
  end
end
