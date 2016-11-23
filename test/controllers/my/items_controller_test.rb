require 'test_helper'

class My::ItemsControllerTest < ActionController::TestCase
  setup do
    @student = create(:student)
    log_user_in(@student)
  end

  should "only show current items" do
    create_list(:item_connection, 3, student:  @student, :expires_on => Date.today - 1.year)
    create_list(:item_connection, 6, student:  @student, :expires_on => Date.today + 1.year)

    session[:terms_accepted] = true
    get :show

    items = assigns(:items)
    assert items
    assert_equal 6, items.size

  end

  should "redirect to terms page if terms not accepted" do
    get :show

    assert_redirected_to my_terms_path
  end
end
