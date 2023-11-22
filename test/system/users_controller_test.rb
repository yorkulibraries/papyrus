require "application_system_test_case"

class UsersControllerTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    Rails.configuration.is_using_login_password_authentication = true
    @user = create(:user, username: 'someuser', password: '12345678')
    sign_in @user
  end
  test "visiting the index" do
    visit root_path

    # assert_selector "h1", text: "ConsistentDesign"
  end
end
