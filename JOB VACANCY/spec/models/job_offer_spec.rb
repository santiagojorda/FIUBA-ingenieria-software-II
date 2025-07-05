require 'spec_helper'

describe JobOffer do
  describe 'valid?' do
    it 'should be invalid when title is blank' do
      check_validation(:title, "Title can't be blank") do
        described_class.new(location: 'a location', remuneration: 1000)
      end
    end

    it 'should be valid when title is not blank' do
      job_offer = described_class.new(title: 'a title', remuneration: 1000)
      expect(job_offer).to be_valid
    end

    xit 'should be invalid when remuneration is blank' do
      check_validation(:remuneration, "Remuneration can't be blank") do
        described_class.new(title: 'a title')
      end
    end

    it 'should be valid when remuneration is not blank' do
      job_offer = described_class.new(title: 'a title', remuneration: 1000)
      expect(job_offer).to be_valid
    end
  end
end
