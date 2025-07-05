class JobOfferRepository < BaseRepository
  self.table_name = :job_offers
  self.model_class = 'JobOffer'

  def all_active
    load_collection dataset.where(is_active: true)
  end

  def find_by_owner(user)
    load_collection dataset.where(user_id: user.id)
  end

  def deactivate_old_offers
    all_active.each do |offer|
      if offer.old_offer?
        offer.deactivate
        update(offer)
      end
    end
  end

  def search_by_title(title)
    load_collection dataset.where(Sequel.like(:title, "%#{title}%"))
  end

  protected

  def load_object(a_record)
    job_offer = super
    # TODO: Eager load user to avoid N+1 queries
    user = UserRepository.new.find(job_offer.user_id)
    job_offer.owner = user
    job_offer
  end

  # group_by devuelve un hash de email y las offers activas que tiene, incluso si no tiene offers
  def group_by(user_email); end

  def changeset(offer)
    {
      title: offer.title,
      location: offer.location,
      description: offer.description,
      remuneration: offer.remuneration,
      is_active: offer.is_active,
      user_id: offer.owner&.id || offer.user_id
    }
  end
end
