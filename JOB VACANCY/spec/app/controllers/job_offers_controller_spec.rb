require 'integration_spec_helper'

describe 'JobOffersController' do
  let(:current_user) do
    user = User.new(name: 'Joe', email: 'joe@doe.com', crypted_password: 'secure_pwd')
    UserRepository.new.save(user)
    user
  end

  let(:signed_in_session) { { 'rack.session' => { 'current_user' => current_user.id } } }

  describe 'get :new' do
    it 'should response ok and render job_offers/new' do
      get '/job_offers/new', {}, signed_in_session
      expect(last_response).to be_ok
    end

    it 'should render job_offers/new' do
      expect_any_instance_of(JobVacancy::App).to receive(:render).with('job_offers/new')
      get '/job_offers/new', {}, signed_in_session
    end
  end
end
