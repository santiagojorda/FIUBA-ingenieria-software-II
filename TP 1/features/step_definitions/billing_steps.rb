require 'json'

Given('user {string} with an on-demand susbcription') do |user_email|
  @user = User.create(user_email, user_email, 'Pass12$ord!45')
  UserRepository.new.save(@user)
end

Given('there are no offers at all') do
  JobOfferRepository.new.delete_all
end

When('I get the billing report') do
  visit 'reports/billing'
  @report_as_json = JSON.parse(page.body)
end

Then('the total active offers is {int}') do |expected_active_offers|
  expect(@report_as_json['total_active_offers']).to eq expected_active_offers
end

Then('the total amount is {float}') do |expected_total_amount|
  expect(@report_as_json['total_amount']).to eq expected_total_amount
end

Given('a user {string} with {string} subscription') do |user_email, subscription_type|
  # JobOfferRepository.new.delete_all
  @user_email = user_email
  @user = User.create(user_email, user_email, 'Pass12$ord!45')
  @user.subscription = (OnDemand.new) if subscription_type == 'on-demand'
  @user.subscription = (Org.new) if subscription_type == 'org'
  UserRepository.new.save(@user)
end

Given('{int} active offers') do |offer_count|
  # JobOfferRepository.new.delete_all
  offer_count.times do |i|
    @offer = JobOffer.new(title: "a nice job #{i}", location: 'a nice place', description: 'a very nice job',
                          remuneration: '100')
    @offer.owner = @user
    @offer.is_active = true
    JobOfferRepository.new.save(@offer)
  end
end

Then('the amount to pay for the user {string} is {float}') do |user_email, expected_amount|
  user = @report_as_json['items'].find { |item| item['user_email'] == user_email }
  expect(user).not_to be_nil
  expect(user['amount_to_pay']).to eq(expected_amount)
end

Then('the total active offers are {int}') do |expected_offer_count|
  expect(@report_as_json['total_active_offers']).to eq expected_offer_count
end

Given('another user {string} with {string} susbcription') do |user_email, subscription_type|
  @user_email = user_email
  @user = User.create(user_email, user_email, 'Pass12$ord!45')
  @user.subscription = (OnDemand.new) if subscription_type == 'on-demand'
  UserRepository.new.save(@user)
end

Given('the user {string} has {int} active offers') do |_user_email, active_offer_count|
  # JobOfferRepository.new.delete_all
  # @user = User.create(user_email, user_email, 'counterStrike')
  active_offer_count.times do |i|
    @offer = JobOffer.new(title: "a ruby job #{i}", location: 'a bad place', description: 'a very horrible job',
                          remuneration: '20000')
    @offer.owner = @user
    @offer.is_active = true
    JobOfferRepository.new.save(@offer)
  end
end

Given('{int} inactive offers') do |inactive_offer_count|
  inactive_offer_count.times do |i|
    @offer = JobOffer.new(title: "a nice job #{i}", location: 'a nice place', description: 'a very nice job',
                          remuneration: '100')
    @offer.owner = @user
    @offer.is_active = false
    JobOfferRepository.new.save(@offer)
  end
end
Then('the billing for this user is {float}') do |expected_amount|
  user = @report_as_json['items'].find { |item| item['user_email'] == @user_email }
  expect(user).not_to be_nil
  expect(user['amount_to_pay']).to eq(expected_amount)
end

Given('the user {string}') do |user_email|
  JobOfferRepository.new.delete_all
  UserRepository.new.delete_all
  @user_email = user_email
  @user = User.create(user_email, user_email, 'Pass12$ord!45')
  UserRepository.new.save(@user)
end

Given('another user with {string} susbcription') do |subscription_type|
  @user_email = 'pedro@pepe.com'
  @user = User.create(@user_email, @user_email, 'Pass12$ord!45')
  @user.subscription = (OnDemand.new) if subscription_type == 'on-demand'
  @user.subscription = (Org.new) if subscription_type == 'org'
  UserRepository.new.save(@user)
end

Given('I am logged in') do
  visit '/login'
  fill_in('user[email]', with: 'pedro@pepe.com')
  fill_in('user[password]', with: 'Pass12$ord!45')
  click_button('Login')
  page.should have_content('pedro@pepe.com')
end

When('I create {int} offers') do |counter|
  JobOfferRepository.new.delete_all
  counter.times do |_i|
    visit '/job_offers/new'
    fill_in('job_offer_form[title]', with: "title#{counter}")
    fill_in('job_offer_form[remuneration]', with: "1000#{counter}")
    click_button('Create')
  end
end

When('I activate {int} offers') do |counter|
  visit '/job_offers/my'

  activated = 0
  while activated < counter
    button = all(:button, 'Activate', wait: 5).first
    break unless button

    button.click
    activated += 1
    visit '/job_offers/my'
  end
end

Then('the last offer should not be active') do
  last_offer = JobOfferRepository.new.all.last
  expect(last_offer.is_active).not_to be true
end

Then('the subscription of {string} is {string}') do |arg1, arg2|
  user = @report_as_json['items'].find { |item| item['user_email'] == arg1 }
  expect(user).not_to be_nil
  expect(user['subscription']).to eq(arg2)
end
