require "application_system_test_case"

class HomeTest < ApplicationSystemTestCase

  test "visiting the index" do
    visit root_url
    assert_selector "body", text: "Register Student"
  end
end
