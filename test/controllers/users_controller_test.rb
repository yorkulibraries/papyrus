require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  setup do
    @manager_user = create(:user, :role => User::MANAGER)

    log_user_in(@manager_user)
  end

  should "only set user to inactive when destroying one" do
    u = create(:user)

    assert_no_difference "User.count" do
      post :destroy, id: u.id
    end

    user = assigns(:user)
    assert_equal true, user.inactive?, "User has been set to inactive"
    assert_redirected_to users_url, "Redirected to users url"
  end

  should "allow to deactivate user event if user has missing fields" do
    u = create(:user)
    u.email = nil
    u.save(validate: false)

    post :destroy, id: u.id

    user = assigns(:user)
    assert_equal true, user.inactive?, "User should be set to inactive"

  end

  should "activate an inactive user" do
    u = create(:user, inactive: true)

    post :activate, id: u.id

    user = assigns(:user)
    assert ! user.inactive?, "User should be active"
    assert_redirected_to users_url, "Redirects to users url"
  end


  should "list all active non-student users" do
    create_list(:user, 2, inactive: false)
    create_list(:user, 2, role: User::STUDENT_USER, inactive: false)

    create_list(:user, 5, inactive: true)

    get :index

    users = assigns(:users)
    assert_equal 3, users.count, "Only 3 active users (2 + 1 logged in)"

  end

  should "list all inactive non student users" do
    create_list(:user, 2, inactive: false)

    create_list(:user, 2, role: User::STUDENT_USER, inactive: true)
    create_list(:user, 5, inactive: true)

    get :inactive

    users = assigns(:users)
    assert_equal 5, users.count, "5 inactive users"
  end


  should "create a new user" do

    assert_difference "User.count", 1 do
      post :create, user: attributes_for(:user)
    end
  end

  should "update an existing user" do
    u = create(:user, username: "old")

    post :update, id: u.id, user: { username: "new" }

    user = assigns(:user)
    assert_equal "new", user.username, "Updated username"
    assert_redirected_to users_url, "redirects to users url"
  end



  should "not create a user when fields are missing" do
    assert_no_difference "User.count" do
      post :create, user: { email: "woot@test.com"}
    end

  end


end
