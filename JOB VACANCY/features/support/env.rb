require File.expand_path("#{File.dirname(__FILE__)}/../../config/boot")

require 'capybara/cucumber'
require 'rspec/expectations'

require 'simplecov'

SimpleCov.start do
  root(File.join(File.dirname(__FILE__), '..', '..'))
  coverage_dir 'reports/coverage'
  add_filter '/spec/'
  add_filter '/features/'
  add_filter '/admin/'
  add_filter '/db/'
  add_filter '/config/'
  add_group 'Models', 'app/models'
  add_group 'Controllers', 'app/controllers'
  add_group 'Helpers', 'app/helpers'
end

user_repository = UserRepository.new
unless user_repository.all.count.positive?
  user = User.new(
    email: 'offerer@test.com',
    name: 'Offerer',
    password: 'Passw0rd!'
  )

  user_repository.save(user)
end

Around do |_scenario, block|
  DB.transaction(rollback: :always, auto_savepoint: true) { block.call }
end

# Capybara.default_driver = :selenium
Capybara.app = JobVacancy::App.tap { |app| }
