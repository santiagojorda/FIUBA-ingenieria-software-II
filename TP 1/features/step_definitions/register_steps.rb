Given('I am on {string}') do |path|
  visit path_to(path)
end

And(/^I fill in valid new user data$/) do
  fill_in('user[name]', with: 'Pedro Buu')
  fill_in('user[email]', with: 'PedroBuu@test.com')
  fill_in('user[password]', with: 'Pass12$ord!45')
  fill_in('user[password_confirmation]', with: 'Pass12$ord!45')
end

Given(/^I fill in valid new user data without password$/) do
  fill_in('user[name]', with: 'Pedro Buu')
  select('on-demand', from: 'user[subscription]')
  fill_in('user[email]', with: 'PedroBuu@test.com')
end

Given('I select the {string} subscription') do |arg|
  select(arg, from: 'user[subscription]')
end

When('I enter a password that meets all the conditions') do
  fill_in('user[password]', with: 'Pass12$ord!45')
  fill_in('user[password_confirmation]', with: 'Pass12$ord!45')
end

When('I enter a password with fewer than 8 characters') do
  fill_in('user[password]', with: 'Pass12$')
  fill_in('user[password_confirmation]', with: 'Pass12$')
end

When('I enter a password with only lowercase letters') do
  fill_in('user[password]', with: 'pass$ord!45$')
  fill_in('user[password_confirmation]', with: 'pass$ord!45$')
end

When('I enter a password with only one number') do
  fill_in('user[password]', with: 'Pass$ord!4$')
  fill_in('user[password_confirmation]', with: 'Pass$ord!4$')
end

When('I enter a password with no special characters') do
  fill_in('user[password]', with: 'Pass12Word54')
  fill_in('user[password_confirmation]', with: 'Pass12Word54')
end

When('I enter a password with more than 15 characters') do
  fill_in('user[password]', with: 'Pass12$ord!45992')
  fill_in('user[password_confirmation]', with: 'Pass12$ord!45992')
end

When('I submit the form') do
  click_button 'Create'
end

Then('I am successfully registered') do
  expect(page).to have_current_path('/')
  expect(page).to have_content('User created')
end

Then('The error {string} is shown') do |error_msg|
  page.should have_content(error_msg)
end

Given(/^I use an email "([^"]*)"$/) do |arg|
  fill_in('user[email]', with: arg)
end

Given(/^I use an email that does not end with \.org$/) do
  fill_in('user[email]', with: 'fran@fi.uba.ar')
end

Then(/^an error is shown saying I must select a subscription type$/) do
  pending
end

Then(/^the error "([^"]*)" is shown$/) do |_arg|
  pending
end
