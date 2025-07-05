class JobOfferFavoriteRepository < BaseRepository
  self.table_name = :job_offers_favorites
  self.model_class = 'JobOfferFavorite'

  def save(job_offer, user)
    raise JobOfferFavoriteError, "Can't Fav your own offers" if job_offer.user_id == user.id

    favorite = find_by_job_offer_and_user(job_offer, user)
    raise JobOfferFavoriteError, 'This offer is already in your favorite list' unless favorite.nil?

    job_offer_favorite = JobOfferFavorite.new(job_offer_id: job_offer.id, user_id: user.id)
    insert(job_offer_favorite)
  end

  def find_by_job_offer_and_user(job_offer, user)
    load_object dataset.where(job_offer_id: job_offer.id, user_id: user.id).first
  end

  protected

  def changeset(job_offer_favorite)
    {
      job_offer_id: job_offer_favorite.job_offer_id,
      user_id: job_offer_favorite.user_id
    }
  end

  def load_object(record)
    return nil if record.nil?

    super
  end
end
