# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Papyrus
  class Application < Rails::Application
    # Version of your assets, change this if you want to expire all your assets
    config.assets.initialize_on_precompile = false

    # values available for "is_authentication_method" are
    # 'devise' (login and pw)
    # 'header' (only yorku setup)
    config.is_authentication_method = ENV.fetch('AUTH_METHOD', 'header').to_sym

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W[#{config.root}/lib]
    config.eager_load_paths << "#{Rails.root}/lib"

    config.time_zone = 'Eastern Time (US & Canada)'

    # Initialize configuration defaults for originally generated Rails version.
    config.action_mailer.delivery_job = 'ActionMailer::MailDeliveryJob'
    config.load_defaults 7.0

    config.filter_parameters += [:password]
    config.active_record.legacy_connection_handling = false

    config.i18n.enforce_available_locales = false

    config.active_record.belongs_to_required_by_default = false
    config.active_record.yaml_column_permitted_classes = [Date, ActiveSupport::TimeWithZone, Time,
                                                          ActiveSupport::TimeZone]
  end
end
