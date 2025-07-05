require 'bundler/setup'
require 'padrino-core/cli/rake'
require 'English'

RACK_ENV = ENV['RACK_ENV'] ||= ENV['RACK_ENV'] ||= 'test' unless defined?(RACK_ENV)

task :version do
  require './lib/version'
  puts Version.current
  exit 0
end

PadrinoTasks.use(:database)
PadrinoTasks.use(:sequel)
PadrinoTasks.init

if %w[development test travis].include?(RACK_ENV)

  task :all do
    ['rake spec', 'rake cucumber', 'rake rubocop'].each do |cmd|
      puts "Starting to run #{cmd}..."
      system("export DISPLAY=:99.0 && bundle exec #{cmd}")
      raise "#{cmd} failed!" unless $CHILD_STATUS.exitstatus.zero?
    end
  end

  task :build_server do
    ['rake spec_report', 'rake cucumber_report', 'rake rubocop'].each do |cmd|
      puts "Starting to run #{cmd}..."
      system("export DISPLAY=:99.0 && bundle exec #{cmd}")
      raise "#{cmd} failed!" unless $CHILD_STATUS.exitstatus.zero?
    end
  end

  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:cucumber) do |task|
    Rake::Task['db:migrate'].invoke
    task.cucumber_opts = ['features', '--tags \'not @wip\'']
  end

  Cucumber::Rake::Task.new(:billing_acceptance_tests) do |task|
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke
    task.cucumber_opts = ['features', '--tags \'@billing\'']
  end

  Cucumber::Rake::Task.new(:feature_indev) do |task|
    Rake::Task['db:migrate'].invoke
    task.cucumber_opts = ['features', '--tags \'@indev\'']
  end

  Cucumber::Rake::Task.new(:cucumber_report) do |task|
    Rake::Task['db:migrate'].invoke
    task.cucumber_opts = ['features', '--format html -o reports/cucumber.html --tags \'not @wip\'']
  end

  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = './spec/**/*_spec.rb'
  end

  RSpec::Core::RakeTask.new(:spec_report) do |t|
    t.pattern = './spec/**/*_spec.rb'
    t.rspec_opts = %w[--format progress --format RspecJunitFormatter --out reports/spec/rspec.xml]
  end

  require 'rubocop/rake_task'
  desc 'Run RuboCop'
  RuboCop::RakeTask.new(:rubocop) do |task|
    task.formatters = %w[simple html]
    task.options = ['-o', 'reports/rubocop.html']
    task.requires << 'rubocop-rspec'
    task.fail_on_error = false
  end

  task default: [:all]

end
