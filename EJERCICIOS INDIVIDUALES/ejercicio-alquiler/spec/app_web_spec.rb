ENV['APP_ENV'] = 'test'
require 'spec_helper'
require_relative '../app_web'
require 'rack/test'

describe 'App web' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

end
