require 'test_helper'

class Students::PermanentDeleteControllerTest < ActionController::TestCase
  setup do
    @user = create(:user, role: User::ADMIN)
    log_user_in(@user)
  end

  should "show a confirmation page" do
    @student = create(:student)
    get :show, id: @student.id
    s = assigns(:student)
    assert_not_nil s
    assert_response :success
  end

  should "permanently destroy students" do
    @student = create(:student)
    assert_difference "Student.count", -1 do
      get :destroy, id: @student.id
      assert_redirected_to students_permanent_delete_index_path
    end
  end

end
