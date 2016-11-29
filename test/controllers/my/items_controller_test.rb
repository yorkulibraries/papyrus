require 'test_helper'

class My::ItemsControllerTest < ActionController::TestCase
  setup do
    @student = create(:student)
    log_user_in(@student)
    session[:terms_accepted] = true
  end

  should "only show current items" do
    create_list(:item_connection, 3, student:  @student, :expires_on => Date.today - 1.year)
    create_list(:item_connection, 6, student:  @student, :expires_on => Date.today + 1.year)

    
    get :show

    items = assigns(:items)
    assert items
    assert_equal 6, items.size

  end


end
