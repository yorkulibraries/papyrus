ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
include ActionDispatch::TestProcess


begin
  require 'turn/autorun'
  Turn.config.format = :progress
rescue LoadError
  puts 'Install the Turn gem for prettier test output.'
end

PapyrusConfig.reset_defaults

# Test::Unit
class Test::Unit::TestCase
  #include ActionDispatch::TestProcess
end


class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting


  #fixtures :all


  # Add more helper methods to be used by all tests here...
  include FactoryGirl::Syntax::Methods


end

class ActionController::TestCase

  def log_user_in(user)
    session[:user_id] = user.id
  end


end
