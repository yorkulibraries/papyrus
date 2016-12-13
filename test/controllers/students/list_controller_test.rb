require 'test_helper'

class Students::ListControllerTest < ActionController::TestCase
  setup do
    @user = create(:user, role: User::ADMIN)
    log_user_in(@user)
  end

  should "list never logged in students" do

    create(:student, last_active_at: nil)
    create_list(:student, 3, last_active_at: 3.days.ago)

    get :never_logged_in
    students = assigns(:students)
    assert_equal 1, students.size, "Should be 1 never logged in student"
    assert_template :never_logged_in
  end

  should "list inactive in students" do

    create_list(:student, 2, inactive: false)
    create_list(:student, 5, inactive: true)

    get :inactive
    students = assigns(:students)
    assert_equal 5, students.size, "There should be 5 inactive students"
  end

  should "list blocked in students" do

    create_list(:student, 2, blocked: false)
    create_list(:student, 5, blocked: true)

    get :blocked
    students = assigns(:students)
    assert_equal 5, blocked.size, "There should be 5 blocked students"
  end

end
