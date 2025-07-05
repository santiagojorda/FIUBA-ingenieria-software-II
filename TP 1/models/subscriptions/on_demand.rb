class OnDemand
  def initialize; end

  def calculate_costs(active_offers)
    10 * active_offers
  end

  def type
    'on-demand'
  end

  def activate_offer(offer, _active_offers)
    offer.activate
  end
end
