# Defines our constants
RACK_ENV = ENV['RACK_ENV'] ||= 'development' unless defined?(RACK_ENV)
PADRINO_ROOT = File.expand_path('..', __dir__) unless defined?(PADRINO_ROOT)

# Load our dependencies
require 'bundler/setup'
Bundler.require(:default, RACK_ENV)

def configure_custom_logger
  require 'semantic_logger'
  log_levels = {
    'fatal' => 4,
    'error' => 3,
    'warn' => 2,
    'info' => 1,
    'debug' => 0
  }
  log_level = ENV['LOG_LEVEL'] || 'debug'
  log_url = ENV['LOG_URL']
  app_name = 'JobVacancy'
  SemanticLogger.default_level = log_levels[log_level]
  SemanticLogger.add_appender(application: app_name, io: $stdout, formatter: :json)
  unless log_url.nil? || log_url.empty?
    SemanticLogger.add_appender(
      appender: :http,
      url: log_url,
      application: app_name
    )
  end
  customer_logger = SemanticLogger['default_logger']
  customer_logger.extend(Padrino::Logger::Extensions)
  Padrino.logger = customer_logger
end

#
# # Enable devel logging
#
# Padrino::Logger::Config[:development][:log_level]  = :devel
# Padrino::Logger::Config[:development][:log_static] = true
#
# # Configure your I18n
#
# I18n.default_locale = :en
#
# # Configure your HTML5 data helpers
#
# Padrino::Helpers::TagHelpers::DATA_ATTRIBUTES.push(:dialog)
# text_field :foo, :dialog => true
# Generates: <input type="text" data-dialog="true" name="foo" />
#
# # Add helpers to mailer
#
# Mail::Message.class_eval do
#   include Padrino::Helpers::NumberHelpers
#   include Padrino::Helpers::TranslationHelpers
# end

#
# Add your before (RE)load hooks here
#

Padrino.before_load do
  configure_custom_logger if ENV['ENABLE_CUSTOM_LOGGER']
  Sequel::Model.plugin :validation_helpers
  Padrino.dependency_paths << Padrino.root('app/repositories/**/*.rb')
  Padrino.dependency_paths << Padrino.root('app/security/**/*.rb')
  Padrino.dependency_paths << Padrino.root('app/forms/**/*.rb')
end

#
# Add your after (RE)load hooks here
#
Padrino.after_load do
end

Padrino.load!
