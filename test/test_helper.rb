# frozen_string_literal: true

ENV['RAILS_ENV'] = 'test'
require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'
require 'database_cleaner'
require 'capybara/rails'
require 'capybara/minitest'

Capybara.server_host = '0.0.0.0'
Capybara.app_host = "http://#{Socket.gethostname}:#{Capybara.server_port}"
Capybara.register_driver :custom_headers_driver do |app|
  Capybara::RackTest::Driver.new(app, headers: { PapyrusSettings.auth_cas_header.to_s => 'TEST' })
end

module ActiveSupport
  class TestCase
    include ActionDispatch::TestProcess
    # Make the Capybara DSL available in all integration tests
    include Capybara::DSL
    # Make `assert_*` methods behave like Minitest assertions
    include Capybara::Minitest::Assertions

    def setup
      PapyrusSettings.worldcat_key = ENV['WORLDCAT_API_KEY']
      PapyrusSettings.primo_apikey = ENV['PRIMO_API_KEY']
      PapyrusSettings.alma_apikey = ENV['ALMA_API_KEY']
      Rails.configuration.is_using_login_password_authentication = false
    end

    def teardown
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
