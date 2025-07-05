Given('I am logged in as a user') do
  visit '/login'
  fill_in('user[email]', with: 'offerer@test.com')
  fill_in('user[password]', with: 'Pass12$ord!45')
  click_button('Login')
  page.should have_content('offerer@test.com')
end

Given('the user {string} create an offer') do |user_email|
  @user_repo = UserRepository.new
  @job_offer_repo = JobOfferRepository.new

  other_user = User.new(
    email: user_email,
    name: 'otheruser2',
    password: 'Pass12$ord!45'
  )
  other_user.subscription = OnDemand.new
  @user_repo.save(other_user)
  @other_user = @user_repo.find_by_email(other_user.email)

  job_offer = JobOffer.new(title: 'a nice job', location: 'a nice place', description: 'a very nice job',
                           remuneration: '100', is_active: true)
  job_offer.owner = @other_user
  @job_offer_repo.save(job_offer)
  @job_offer = @job_offer_repo.find_by_owner(@other_user).first
end

When('I click the Fav button of an offer') do
  expect(page).to have_content('Fav')
  click_button('Fav')
end

Then('the offer is added to my favorites') do
  current_user = @user_repo.find_by_email('offerer@test.com')
  job_offer_favorite_repo = JobOfferFavoriteRepository.new
  job_offer_favorite = job_offer_favorite_repo.find_by_job_offer_and_user(@job_offer, current_user)
  expect(job_offer_favorite).not_to be_nil
  expect(job_offer_favorite.job_offer_id).to eq(@job_offer.id)
  expect(job_offer_favorite.user_id).to eq(current_user.id)
end

Then('a notification {string} is shown') do |message|
  page.should have_content(message)
end

When('I click the Fav button of an offer that is mine') do
  current_user = @user_repo.find_by_email('offerer@test.com')
  job_offer = JobOffer.new(title: 'a wonderful job', location: 'a wonderful place', description: 'a very wonderful job',
                           remuneration: '100', is_active: true)
  job_offer.owner = current_user
  @job_offer_repo.save(job_offer)
  @job_offer = @job_offer_repo.find_by_owner(current_user).first
  expect(@job_offer).not_to be_nil
  expect(@job_offer.user_id).to eq(current_user.id)

  visit '/job_offers'
  expect(page).to have_content('a wonderful job')
  within(:xpath, "//tr[td[contains(text(), 'a wonderful job')]]") do
    click_button('Fav')
  end
end

Given('the offer {string} is available') do |offer_name|
  job_offer = JobOffer.new(title: offer_name, location: 'a nice place', description: 'a very nice job',
                           remuneration: '100', is_active: true)
  job_offer.owner = @other_user
  @job_offer_repo.save(job_offer)
  offers = @job_offer_repo.find_by_owner(@other_user)
  exists = offers.any? { |offer| offer.title == offer_name }
  expect(exists).to be true
end

Given('I already add the offer {string} to my favorites') do |offer_name|
  current_user = @user_repo.find_by_email('offerer@test.com')

  job_offer = @job_offer_repo.find_by_owner(@other_user).find { |offer| offer.title == offer_name }

  job_offer_favorite_repo = JobOfferFavoriteRepository.new
  job_offer_favorite_repo.save(job_offer, current_user)

  job_offer_favorite = job_offer_favorite_repo.find_by_job_offer_and_user(job_offer, current_user)
  expect(job_offer_favorite).not_to be_nil
  expect(job_offer_favorite.job_offer_id).to eq(job_offer.id)
  expect(job_offer_favorite.user_id).to eq(current_user.id)
end

When('I click the Fav button of the offer {string}') do |offer_name|
  visit '/job_offers'
  expect(page).to have_content(offer_name)
  within(:xpath, "//tr[td[contains(text(), '#{offer_name}')]]") do
    expect(page).to have_content('Fav')
    click_button('Fav')
  end
end
