When('I create a new offer with {string} as a remuneration') do |remuneration|
  visit '/job_offers/new'
  fill_in('job_offer_form[title]', with: 'title')
  fill_in('job_offer_form[remuneration]', with: remuneration)
  click_button('Create')
end

Then(/^I should see "(.*?)" in my offers list remuneration$/) do |content|
  visit '/job_offers/my'
  page.should have_content(content)
end