require 'spec_helper'

describe User do
  subject(:user) { described_class.new({}) }

  describe 'model' do
    it { is_expected.to respond_to(:id) }
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:crypted_password) }
    it { is_expected.to respond_to(:email) }
  end

  describe 'valid?' do
    it 'should be false when name is blank' do
      user = described_class.new(email: 'john.doe@someplace.com',
                                 crypted_password: 'a_secure_passWord!')
      expect(user.valid?).to eq false
      expect(user.errors).to have_key(:name)
    end

    it 'should be false when email is not valid' do
      user = described_class.new(name: 'John Doe', email: 'john',
                                 crypted_password: 'a_secure_passWord!')
      expect(user.valid?).to eq false
      expect(user.errors).to have_key(:email)
    end

    it 'should be false when password is blank' do
      user = described_class.new(name: 'John Doe', email: 'john')
      expect(user.valid?).to eq false
      expect(user.errors).to have_key(:crypted_password)
    end

    it 'should be true when all field are valid with cryped password' do
      user = described_class.new(name: 'John Doe', email: 'john@doe.com',
                                 crypted_password: 'a_secure_passWord!')
      expect(user.valid?).to eq true
    end

    it 'should be true when all field are valid with password' do
      user = described_class.new(name: 'John Doe', email: 'john@doe.com',
                                 password: 'Pass$ord!45$')
      expect(user.valid?).to eq true
    end

    it 'should be valid with all allowed special characters' do
      allowed_special_chars = User::ALLOWED_SPECIAL_CHARS.chars.each_slice(6).to_a
      allowed_special_chars.each_with_index do |chars, index|
        password = "Pass#{chars.join}12"
        user = described_class.new(name: "John Doe #{index + 1}",
                                   email: "john#{index + 1}@doe.com",
                                   password:)
        expect(user.valid?).to eq true
      end
    end

    it 'should raise error when password is too short' do
      expect do
        described_class.new(name: 'John Doe', email: 'john@doe.com', password: 'aSecu')
      end.to raise_error(PasswordInvalid, 'Password must be at least 8 characters long')
    end

    it 'should generate an error when the password does not have uppercase characters' do
      expect do
        described_class.new(name: 'John Doe', email: 'john@doe.com', password: 'pass$ord!45$')
      end.to raise_error(PasswordInvalid, 'Password must contain at least one uppercase letter')
    end

    it 'should generate an error when the password does not have two numbers' do
      expect do
        described_class.new(name: 'John Doe', email: 'john@doe.com', password: 'Pass$ord!4$')
      end.to raise_error(PasswordInvalid, 'Password must contain at least two numbers')
    end

    it 'should generate an error when the password does not have a special character' do
      expect do
        described_class.new(name: 'John Doe', email: 'john@doe.com', password: 'Password42')
      end.to raise_error(PasswordInvalid, 'Password must contain at least one special character')
    end

    it 'should generate an error when the password is too long' do
      expect do
        described_class.new(name: 'John Doe', email: 'john@doe.com', password: 'Pass12$ord!45992')
      end.to raise_error(PasswordInvalid, 'Password must not exceed 15 characters')
    end
  end

  describe 'has password?' do
    let(:password) { 'Pass12$ord!45' }
    let(:user) do
      described_class.new(password:,
                          email: 'john.doe@someplace.com',
                          name: 'john doe')
    end

    it 'should return false when password do not match' do
      expect(user).not_to have_password('invalid')
    end

    it 'should return true when password do  match' do
      expect(user).to have_password(password)
    end
  end

  describe 'subscriptions: ' do
    it 'should return true when subscription is on-demand as default' do
      user = described_class.new(email: 'johnatan.tip@someplace.com',
                                 name: 'johnatan tip')
      expect(user.subscription).to be_a(OnDemand)
    end

    it 'setting a subscription type makes the user have that subscription' do
      user = described_class.new(email: 'johnny.bravo@someplace.com',
                                 name: 'johnny bravo')
      subs = instance_double(OnDemand)
      user.subscription = (subs)
      expect(user.subscription).to eq(subs)
    end

    it 'should return the amount to pay based on its subscription' do
      user = described_class.new(email: 'messi.tip@someplace.com',
                                 name: 'messi goat')
      subs = instance_double(OnDemand)
      allow(subs).to receive(:calculate_costs).and_return(20)
      user.subscription = (subs)
      amount_to_pay = user.calculate_amount_to_pay(2)
      expect(amount_to_pay).to eq(20)
    end

    it 'should return string of subscription type' do
      user = described_class.new(email: 'messi.tip@someplace.com',
                                 name: 'messi goat')
      subs = instance_double(OnDemand)
      allow(subs).to receive(:type).and_return('on-demand')
      user.subscription = (subs)
      expect(user.subscription_type).to eq('on-demand')
    end

    it 'should activate the offer through the user subscription' do
      job_offer = instance_double(JobOffer)
      expect(job_offer).to receive(:activate)
      allow(job_offer).to receive(:is_active).and_return(true)
      subscription = instance_double(OnDemand)
      allow(subscription).to receive(:activate_offer) do |offer, _active_offers|
        offer.activate
      end
      user = described_class.new(email: 'messi.tip@someplace.com', name: 'messi goat')
      user.instance_variable_set(:@subscription, subscription)
      active_offers = 2
      user.activate_offer(job_offer, active_offers)
      expect(job_offer.is_active).to be true
    end
  end
end
