require 'spec_helper'

describe JobOffer do
  describe 'valid?' do
    it 'should be invalid when title is blank' do
      check_validation(:title, "Title can't be blank") do
        described_class.new(location: 'a location', remuneration: 0)
      end
    end

    it 'should be invalid when remuneration is blank' do
      check_validation(:remuneration, "Remuneration can't be blank") do
        described_class.new(title: 'a title')
      end
    end

    it 'should be invalid when remuneration is not a number' do
      check_validation(:remuneration, 'Remuneration is not a number') do
        described_class.new(title: 'a title', remuneration: 'a number')
      end
    end

    it 'should be valid when title and remuneration is not blank' do
      job_offer = described_class.new(title: 'a title', remuneration: 0)
      expect(job_offer).to be_valid
    end

    # COMENTADO PQ RUBOCOP LLORA
    # xit 'should become active if user activates it' do
    #   job_offer = described_class.new(title: 'a title', remuneration: 0)
    #   allow(job_offer).to receive(:activate).and_call_original
    #   user = instance_double(User)
    #   allow(user).to receive(:activate_offer) { |offer, _active_offers| offer.activate }
    #   job_offer.instance_variable_set(:@user, user)
    #   job_offer.try_activate(2)
    #   expect(job_offer.is_active).to be true
    # end
    #

    it 'should not activate with org subscription user' do
      user = instance_double(User)
      allow(user).to receive(:activate_offer) do |offer, count|
        offer.activate if count < 7
      end
      job_offer = described_class.new(title: 'a title', remuneration: 0)
      job_offer.owner = user
      job_offer.try_activate(7)
      expect(job_offer.is_active).not_to be true
    end
  end
end
