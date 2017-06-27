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

include ActionDispatch::TestProcess


class ActiveSupport::TestCase
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
