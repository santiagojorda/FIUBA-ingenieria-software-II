And(/^I fill in valid new user data minus email$/) do
  fill_in('user[name]', with: 'Pedro Buu')
  fill_in('user[password]', with: 'Pass12$ord!45')
  fill_in('user[password_confirmation]', with: 'Pass12$ord!45')
  select('on-demand', from: 'user[subscription]')
end

When('I enter {string} as an email for new user') do |email|
  fill_in('user[email]', with: email)
end

When('there is a user registered with the email {string}') do |email|
  fill_in('user[email]', with: email)
  step 'I submit the form'
end
