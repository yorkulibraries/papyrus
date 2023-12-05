require 'application_system_test_case'

class HomeTest < ApplicationSystemTestCase
  test 'visiting the index' do
    assert_selector 'body', text: 'Register Student'
  end
end
