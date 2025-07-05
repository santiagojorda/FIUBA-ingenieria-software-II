require 'spec_helper'

describe 'SessionsController' do
  describe 'get :' do
    it 'should response ok' do
      expect_any_instance_of(JobVacancy::App).to receive(:render).with('sessions/new')
      get '/login'
      expect(last_response).to be_ok
    end

    it 'should render users/login' do
      expect_any_instance_of(JobVacancy::App).to receive(:render).with('sessions/new')
      get '/login'
    end
  end
end
