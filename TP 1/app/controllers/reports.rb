JobVacancy::App.controllers :reports, provides: [:json] do
  attr_accessor :repo

  get :billing do
    repo = JobOfferRepository.new
    offer_counter = OfferCounter.new(repo)
    users = UserRepository.new.all

    total_income = 0
    items = users.map do |user|
      active_offers = offer_counter.users_active_offers(user.email)
      subscription = user.subscription.type
      amount = user.calculate_amount_to_pay(active_offers)
      total_income += amount
      {
        user_email: user.email,
        subscription:,
        active_offers_count: active_offers,
        amount_to_pay: amount
      }
    end

    report = {
      'items': items,
      total_active_offers: offer_counter.count_active,
      total_amount: total_income
    }
    return report.to_json
  end
end
