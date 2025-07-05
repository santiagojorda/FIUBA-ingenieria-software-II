require 'spec_helper'

describe 'HealthController' do
  it 'should check database and return ok' do
    allow(Ping).to receive(:create).and_return(Ping.new)
    get '/health'
    expect(last_response).to be_ok
  end

  it 'should include version' do
    get '/health/version'
    expect(last_response.body.include?(Version.current)).to eq(true)
  end
end
