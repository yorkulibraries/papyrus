require 'application_system_test_case'

class HomeTest < ApplicationSystemTestCase

  test 'visiting the index' do
    visit root_url
    assert_selector 'body', text: 'Register Student'
    click_link('Register Student')
    find(:xpath, "//i[@class='fa-search fas']").click
    find_field('Example').value
    # page.save_screenshot('/usr/src/app/screenshot2.png')

    # within(:xpath, "//input[@id='omni_search_field']") do
    #   fill_in 'Example', with: "Search Items or Students"
    # end
  end
end
