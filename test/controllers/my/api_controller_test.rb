require 'test_helper'

class My::ApiControllerTest < ActionController::TestCase

  context "as manager user" do
    setup do
      @user = create(:user, role: User::MANAGER)
      log_user_in(@user)
    end

    should "be able to log in as student" do
      student = create(:student)
      get :login_as_student, id: student.id

      assert_equal student.id, session[:user_id]
      assert_equal @user.id, session[:return_to_user_id]
      assert_response :redirect
      assert_redirected_to my_terms_path
    end

    should "raises error if log in as student not found" do
      assert_raises ActiveRecord::RecordNotFound do
        get :login_as_student, id: "999"
      end
    end

    should "log out as student" do
      student = create(:student)

      session[:user_id] = student.id
      session[:return_to_user_id] = @user.id
      session[:terms_accepted] = false

      get :logout_as_student

      assert_equal nil, session[:return_to_user_id]
      assert_equal @user.id, session[:user_id]
      assert_equal nil, session[:terms_accepted]

      assert_response :redirect
      assert_redirected_to student_path(student)
    end
  end

end
