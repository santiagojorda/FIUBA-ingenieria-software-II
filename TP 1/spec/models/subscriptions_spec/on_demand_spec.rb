require 'spec_helper'

describe OnDemand do
  describe 'calculates costs correctly' do
    it 'it should return cost 0 for 0 active offers' do
      sub = described_class.new
      active_offers = 0
      cost = sub.calculate_costs(active_offers)
      expect(cost).to eq 0
    end

    it 'it should return cost 20 for 2 active offers' do
      sub = described_class.new
      active_offers = 2
      cost = sub.calculate_costs(active_offers)
      expect(cost).to eq 20
    end

    it 'it should return on-demand as type' do
      sub = described_class.new
      expect(sub.type).to eq 'on-demand'
    end

    it 'calls activate on the given job offer' do
      offer = instance_double(JobOffer)
      expect(offer).to receive(:activate)
      subscription = described_class.new
      active_offers = 5
      subscription.activate_offer(offer, active_offers)
    end
  end
end
