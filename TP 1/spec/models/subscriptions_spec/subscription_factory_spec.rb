require 'spec_helper'

describe SubscriptionFactory do
  describe 'create' do
    it 'creates an OnDemand subscription' do
      factory = described_class.new
      subscription = factory.create('on-demand', 'ejemplo@gmail.com')
      expect(subscription).to be_a(OnDemand)
    end

    it 'creates an Org subscription' do
      factory = described_class.new
      subscription = factory.create('org', 'pedro@hotmail.org')
      expect(subscription).to be_a(Org)
    end

    it 'creates an OnDemand subscription for invalid inputs' do
      factory = described_class.new
      subscription = factory.create('invalid', '123@gmail.com')
      expect(subscription).to be_a(OnDemand)
    end

    it 'creates an org subs with email finished in .org return a Org' do
      factory = described_class.new
      subscription = factory.create('org', 'fran@gmail.org')
      expect(subscription).to be_a(Org)
    end

    it 'creates an org subs with email finished in .com return an exception' do
      factory = described_class.new
      expect { factory.create('org', 'fran@gmail.com') }.to raise_error(EmailInvalid)
    end

    it 'invalid subscription return a exception' do
      factory = described_class.new
      expect { factory.create('', 'fran@gmail.com') }.to raise_error(SubscriptionInvalid)
    end
  end
end
