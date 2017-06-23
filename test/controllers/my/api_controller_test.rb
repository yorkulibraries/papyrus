require 'test_helper'

class My::ApiControllerTest < ActionDispatch::IntegrationTest

  context "as manager user" do
    setup do
      @user = create(:user, role: User::MANAGER)
      log_user_in(@user)
    end

    should "be able to log in as student" do
      student = create(:student)
      get my_login_as_student_path(student)

      assert_equal student.id, session[:user_id]
      assert_equal @user.id, session[:return_to_user_id]
      assert_response :redirect
      assert_redirected_to my_terms_path
    end

    should "raises error if log in as student not found" do
      assert_raises ActiveRecord::RecordNotFound do
        get my_login_as_student_path(999)
      end
    end

    should "log out as student" do
      student = create(:student)

      get my_login_as_student_path(student)
      patch my_terms_path

      get my_logout_as_student_path

      assert_nil session[:return_to_user_id]
      assert_equal @user.id, session[:user_id]
      assert_nil session[:terms_accepted]

      assert_response :redirect
      assert_redirected_to student_path(student)
    end
  end

end
