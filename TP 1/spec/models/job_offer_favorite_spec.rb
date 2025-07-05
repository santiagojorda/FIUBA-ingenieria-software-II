require 'spec_helper'

describe JobOfferFavorite do
  describe 'valid?' do
    it 'should be invalid when job_offer_id is blank' do
      check_validation(:job_offer_id, "Job offer can't be blank") do
        described_class.new(job_offer_id: nil, user_id: 1)
      end
    end

    it 'should be invalid when user_id is blank' do
      check_validation(:user_id, "User can't be blank") do
        described_class.new(job_offer_id: 1, user_id: nil)
      end
    end
  end
end
