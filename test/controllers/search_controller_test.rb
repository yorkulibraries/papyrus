require 'test_helper'

class SearchControllerTest < ActionController::TestCase

  setup do
    @user = create(:user)
    log_user_in(@user)
  end

  should "search local items if no type is specified" do
    create(:item, title: "unique title")
    create(:item, isbn: "9-233-12345")
    create(:item, unique_id: "000111")
    create(:item, author: "john smith")


    get :items, q: "unique"
    search_results = assigns(:search_results)
    assert_equal "local", search_results, "search results should be set to local"
    assert_response :success
    assert_template :items

    items = assigns(:items)
    assert_equal "unique title", items.first.title

    get :items, q: "9-233"
    items = assigns(:items)
    assert_equal "9-233-12345", items.first.isbn

    get :items, q: "000111"
    items = assigns(:items)
    assert_equal "000111", items.first.unique_id

    get :items, q: "john"
    items = assigns(:items)
    assert_equal "john smith", items.first.author

  end

  should "search students" do
    create(:student, name: "Terry Jones", username: "terryjones", email: "tj@yorku.ca", inactive: false)
    create(:student, name: "Valmar Garry", username: "vgarry", email: "vg@university.ca", inactive: true)

    get :students, q: "Terry Jones"
    students = assigns(:students)
    assert_equal 1, students.size, "One student found with that name"

    get :students, q: "vgarry"
    students = assigns(:students)
    assert_equal 0, students.size, "No one should be found, since vgarry is inactive"

    get :students, q: "vg@university.ca", inactive: true
    students = assigns(:students)
    assert_equal 1, students.size, "Should find one inactive student"

    get :students, q: "terry", inactive: true
    students = assigns(:students)
    assert_equal 0, students.size, "Should find no student student since Terry is active"
  end


end
