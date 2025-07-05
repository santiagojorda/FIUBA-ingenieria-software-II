Given('I am on {string} with a active offer') do |path|
  @offer = JobOffer.new(title: 'a ruby job', location: 'a bad place', description: 'a very horrible job',
                        remuneration: '20000')
  user = User.create('pedro@fi.uba', 'pedro@fi.uba', 'Pass12$ord!45')
  user.subscription = (OnDemand.new)
  UserRepository.new.save(user)
  @offer.owner = user
  @offer.is_active = true
  JobOfferRepository.new.save(@offer)
  visit path_to(path)
end

And(/^I apply to an Offer$/) do
  click_link 'Apply'
end

When(/^I enter "([^"]*)" as an email for applying$/) do |arg|
  fill_in('job_application_form[applicant_email]', with: arg)
end

And(/^I click the "([^"]*)" button$/) do |arg|
  click_button arg
end
