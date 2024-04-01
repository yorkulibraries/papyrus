# frozen_string_literal: true

ENV['RAILS_ENV'] = 'test'
require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'
require 'database_cleaner'
require 'capybara/rails'
require 'capybara/minitest'

DatabaseCleaner.url_allowlist = [
  %r{.*test.*}
]
DatabaseCleaner.strategy = :truncation

Capybara.server_host = '0.0.0.0'
Capybara.app_host = "http://#{Socket.gethostname}:#{Capybara.server_port}"

module ActiveSupport
  class TestCase
    include ActionDispatch::TestProcess
    # Make the Capybara DSL available in all integration tests
    include Capybara::DSL
    # Make `assert_*` methods behave like Minitest assertions
    include Capybara::Minitest::Assertions

    setup do
      Rails.configuration.is_authentication_method = :header
      DatabaseCleaner.start
    end

    teardown do
      Capybara.reset_sessions!
      Capybara.use_default_driver
      Attachment.all.each do |a|
        f = "#{Rails.public_path}#{a.file}"
        File.delete(f) if File.exist?(f) && File.file?(f)
        if a.deleted
          f = "#{File.dirname(a.file.file.path)}/deleted/#{a.id}-#{a.file.file.filename}"
          File.delete(f) if File.exist?(f) && File.file?(f)
        end
      end
      Document.all.each do |a|
        f = "#{Rails.public_path}#{a.attachment}"
        File.delete(f) if File.exist?(f)
      end
      CarrierWave.clean_cached_files! 0
      PapyrusSettings.clear_cache
      DatabaseCleaner.clean
    end

    include FactoryGirl::Syntax::Methods
    include ActiveJob::TestHelper
  end
end

module ActionDispatch
  class IntegrationTest
    def log_user_in(user)
      get login_url, headers: { PapyrusSettings.auth_cas_header.to_s => user.username }
    end
  end
end
