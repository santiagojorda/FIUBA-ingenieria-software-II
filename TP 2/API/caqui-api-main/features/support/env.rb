# rubocop:disable all
ENV['APP_MODE'] = 'test'
ENV['TEST_ENV'] = 'test'
require 'rack/test'
require 'rspec/expectations'
require_relative '../../app.rb'
require 'faraday'
require 'dotenv/load'
require 'webmock/cucumber'

Sequel.extension :migration
logger = Configuration.logger
db = Configuration.db
db.loggers << logger
Sequel::Migrator.run(db, 'db/migrations')


include Rack::Test::Methods
def app
  Sinatra::Application
end

Before do 
    stub_request(:get, %r{#{ProveedorFeriadosNoLaborables::URL_API}/\d{4}})
    .to_return(status: 200, body: '[{"motivo":"Feriado Cucumber Default","tipo":"inamovible","dia":1,"mes":1}]')
end

After do |_scenario|
  Faraday.post('/reset')
  RepositorioMedicos.new.delete_all
  RepositorioEspecialidades.new.delete_all
  RepositorioPacientes.new.delete_all
  RepositorioTurnos.new.delete_all
  RepositorioReputaciones.new.delete_all
end
