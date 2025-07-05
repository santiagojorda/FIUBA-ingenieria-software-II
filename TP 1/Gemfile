source 'https://rubygems.org'

ruby '3.1.2'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Server requirements
gem 'thin'

# Project requirements
gem 'rake'

# Component requirements
gem 'activemodel', require: 'active_model'
gem 'pg', '~> 0.18'
gem 'sequel'

gem 'bcrypt'
gem 'clockwork'
gem 'erubis', '~> 2.7.0'
gem 'json'
gem 'net-smtp'
gem 'semantic_logger'

# Padrino Stable Gem
gem 'padrino', '~> 0.14'

group :development, :test do
  gem 'capybara'
  gem 'cucumber'
  gem 'debug'
  gem 'nokogiri', '1.8'
  gem 'rack-test', require: 'rack/test'
  gem 'rspec'
  gem 'rspec_junit_formatter'
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
  gem 'simplecov'
end

group :development do
  gem 'guard'
  gem 'guard-rspec'
end
