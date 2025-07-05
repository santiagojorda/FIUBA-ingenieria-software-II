require 'integration_spec_helper'

describe JobOfferFavoriteRepository do
  let(:favorite_repository) { described_class.new }
  let(:job_offer_repository) { JobOfferRepository.new }

  let(:owner) do
    user = User.new(name: 'Joe', email: 'joe@doe.com', crypted_password: 'secure_pwd')
    UserRepository.new.save(user)
    user
  end

  let(:other_user) do
    user = User.new(name: 'Joe', email: 'joe2@doe.com', crypted_password: 'secure_pwd')
    UserRepository.new.save(user)
    user
  end

  describe 'saves a favorite job_offer for user' do
    it 'saves a job_offer in user favorite list' do
      job_offer = JobOffer.new(title: 'a new title', updated_on: Date.today, is_active: true,
                               user_id: owner.id, remuneration: 10)
      job_offer_repository.save(job_offer)
      saved_offer = job_offer_repository.find(job_offer.id)

      favorite_repository.save(saved_offer, other_user)

      favorite = favorite_repository.find_by_job_offer_and_user(saved_offer, other_user)
      expect(favorite.user_id).to eq other_user.id
      expect(favorite.job_offer_id).to eq saved_offer.id
    end
  end

  describe 'does not save a favorite job_offer for user' do
    it 'should generate an error when the user_id is the same as the job_offer owner' do
      job_offer = JobOffer.new(title: 'a new title', updated_on: Date.today, is_active: true,
                               user_id: owner.id, remuneration: 10)
      job_offer_repository.save(job_offer)
      saved_offer = job_offer_repository.find(job_offer.id)

      expect do
        favorite_repository.save(saved_offer, owner)
      end.to raise_error(JobOfferFavoriteError, "Can't Fav your own offers")
    end

    it 'should error when the user tries to favorite an already favorited offer' do
      job_offer = JobOffer.new(title: 'a new title', updated_on: Date.today, is_active: true,
                               user_id: other_user.id, remuneration: 10)
      job_offer_repository.save(job_offer)

      favorite_repository.save(job_offer, owner)

      expect do
        favorite_repository.save(job_offer, owner)
      end.to raise_error(JobOfferFavoriteError, 'This offer is already in your favorite list')
    end
  end
end
