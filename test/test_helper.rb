ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
include ActionDispatch::TestProcess

#begin
  #require 'turn/autorun'
  #Turn.config.format = :progress
#rescue LoadError
  #puts 'Install the Turn gem for prettier test output.'
#end
require 'database_cleaner/active_record'
require 'minitest'

DatabaseCleaner.strategy = :transaction
DatabaseCleaner.clean_with(:truncation)
Rails.application.load_seed

# with the minitest-around gem, this may be used instead:
class Minitest::Spec
  around do |tests|
    DatabaseCleaner.cleaning(&tests)
    Rails.application.load_seed
  end
end

include ActionDispatch::TestProcess

class ActiveSupport::TestCase
  def setup
    api_keys = Rails.application.config_for :api_keys
    PapyrusSettings[:worldcat_key] = api_keys[:worldcat_api_key]
    PapyrusSettings[:primo_api_key] = api_keys[:primo_api_key]
    PapyrusSettings[:alma_api_key] = api_keys[:alma_api_key]
  end

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting

  #fixtures :all

  # Add more helper methods to be used by all tests here...
  include FactoryGirl::Syntax::Methods

  include ActiveJob::TestHelper 
end

class ActionDispatch::IntegrationTest
  PapyrusSettings.expire_cache

  def log_user_in(user)
    #session[:user_id] = user.id
    get login_url, headers: { "#{PapyrusSettings.auth_cas_header}" => user.username }
  end
end
