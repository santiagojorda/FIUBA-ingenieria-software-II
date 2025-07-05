require 'spec_helper'

describe OfferCounter do
  describe 'count_active' do
    it 'should be 0 when no active offers' do
      repo = instance_double('offer_repo', all_active: [])
      counter = described_class.new(repo)
      expect(counter.count_active).to eq 0
    end

    it 'should find a user and count the user\'s active offers' do
      user_fran = instance_double('User', email: 'fran@fiuba.com')

      offer1 = instance_double('Offer', user: user_fran)
      offer2 = instance_double('Offer', user: user_fran)
      repo = instance_double('offer_repo', all_active: [offer1, offer2])

      counter = described_class.new(repo)

      expect(counter.users_active_offers('fran@fiuba.com')).to eq 2
    end
  end
end
