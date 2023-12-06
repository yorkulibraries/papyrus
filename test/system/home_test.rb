require 'application_system_test_case'

class HomeTest < ApplicationSystemTestCase
  test 'Display menu, adding an Item, search item through modal' do
    ITEM_NAME = 'York manual'
    assert_selector 'body', text: 'Register Student'

    # Dropdown menu
    click_link('New Item')
    click_link('Blank Item')

    # Adding item
    fill_in('Full Title', with: ITEM_NAME)
    select('Book', from: 'Item Type')
    click_button('Create Item')

    # Search in modal
    assert_no_selector '#omni_search_modal.visible'
    find('#global_search').click

    # Wait for the modal to be visible
    assert_selector '#omni_search_modal'

    fill_in 'Search Items or Students', with: ITEM_NAME
    find('#omni_search_button').click
    click_link(ITEM_NAME)

    # find('button.btn-secondary[data-bs-dismiss="modal"]').click
    # page.save_screenshot('/usr/src/app/example.png')
  end
end
