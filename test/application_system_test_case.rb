require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :custom_headers_driver, using: :chrome, screen_size: [1400, 1400], options: {
    browser: :remote,
    url: "http://#{ENV.fetch("SELENIUM_SERVER")}:4444"
  }
  def setup
    @user = create(:user, username: "TEST")
  end
end
