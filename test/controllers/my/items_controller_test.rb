# frozen_string_literal: true

require 'test_helper'

module My
  class ItemsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @student = create(:student)
      log_user_in(@student)
      patch my_terms_path
    end

    should 'only show current items' do
      create_list(:item_connection, 3, student:  @student, expires_on: Date.today - 1.year)
      create_list(:item_connection, 6, student:  @student, expires_on: Date.today + 1.year)

      get my_items_path

      items = assigns(:items)
      assert items
      assert_equal 6, items.size
    end
  end
end
