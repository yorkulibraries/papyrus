require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400], options: {
    browser: :remote,
    url: "http://#{ENV.fetch('SELENIUM_SERVER')}:4444"
  }
  def setup
    Rails.configuration.is_authentication_method = :devise
  end
end
