class Org
  def initialize; end

  def calculate_costs(active_offers)
    0 * active_offers
  end

  def type
    'org'
  end

  def activate_offer(offer, active_offers)
    offer.activate if active_offers < 7
  end
end
