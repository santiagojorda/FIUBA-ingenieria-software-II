require 'integration_spec_helper'

describe GateKeeper do
  let(:gate_keeper) { described_class.new }

  let(:valid_password) { 'secure_pwd' }
  let(:invalid_password) { 'invalid_pwd' }

  let(:current_user) do
    user = User.new(name: 'Joe', email: 'joe@doe.com', password: valid_password)
    UserRepository.new.save(user)
    user
  end

  describe 'sign in succeed' do
    it 'should run succeed callback' do
      gate_keeper.authenticate(current_user.email, valid_password).when_succeed do |user|
        expect(user.id).to eq(current_user.id)
      end
    end

    it 'should not run failed callback' do
      gate_keeper.authenticate(current_user.email, valid_password).when_failed do
        raise 'should not call me'
      end
    end
  end

  describe 'sign in failed' do
    it 'should run succeed callback' do
      gate_keeper.authenticate(current_user.email, invalid_password).when_succeed do |_user|
        raise 'should not call me'
      end
    end

    it 'should not run failed callback' do
      failed_callback_called = false
      gate_keeper.authenticate(current_user.email, invalid_password).when_failed do
        failed_callback_called = true
      end
      expect(failed_callback_called).to eq(true)
    end
  end
end
