class OfferCounter
  def initialize(offer_repo)
    @repo = offer_repo
  end

  def count_active
    @repo.all_active.size
  end

  def users_active_offers(email)
    @repo.all_active.select { |offer| offer.user.email == email }.size
  end
end
