require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400], options: {
    browser: :remote,
    url: "http://#{ENV.fetch('SELENIUM_SERVER')}:4444"
  }

  def setup
    Rails.configuration.is_authentication_method = :devise
    create(:user, role: User::ADMIN, email: 'test@test.com', password: '12345678')
    visit root_url
    fill_in('Email', with: 'test@test.com')
    fill_in('Password', with: '12345678')
    click_on('Log In')
  end
end
