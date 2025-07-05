require 'spec_helper'

describe 'UsersController' do
  describe 'get :register' do
    it 'should response ok' do
      get '/register'
      expect(last_response).to be_ok
    end

    it 'should render users/new' do
      expect_any_instance_of(JobVacancy::App).to receive(:render).with('users/new')
      get '/register'
    end
  end
end
