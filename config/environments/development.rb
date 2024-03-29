# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  config.eager_load = false

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # set delivery method to :smtp, :sendmail or :test
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = { address: 'mail', port: 1025 }
  config.action_mailer.default_url_options = { host: 'localhost:' + ENV['PORT'] }

  # Expands the lines which load the assets
  config.assets.debug = true
  config.assets.digest = false
  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  config.cache_store = :memory_store

  config.log_tags = %i[uuid remote_ip]

  config.web_console.permissions = '192.168.168.1/16'
  config.logger = Logger.new(STDOUT)
  config.log_level = :debug
end
