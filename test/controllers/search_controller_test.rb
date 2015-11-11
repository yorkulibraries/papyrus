require 'test_helper'

class SearchControllerTest < ActionController::TestCase

  setup do
    @user = create(:user)
    log_user_in(@user)
  end

  should "search items database if no type was specified" do
    create(:item, title: "unique title")
    create(:item, isbn: "9-233-12345")
    create(:item, unique_id: "000111")
    create(:item, author: "john smith")


    get :index, q: "unique"
    search_results = assigns(:search_results)
    assert_equal "local", search_results, "search results should be set to local"
    assert_response :success
    assert_template :index

    items = assigns(:items)
    assert_equal "unique title", items.first.title

    get :index, q: "9-233"
    items = assigns(:items)
    assert_equal "9-233-12345", items.first.isbn

    get :index, q: "000111"
    items = assigns(:items)
    assert_equal "000111", items.first.unique_id

    get :index, q: "john"
    items = assigns(:items)
    assert_equal "john smith", items.first.author

  end

end
