require 'test_helper'

class Students::PermanentDeleteControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user, role: User::ADMIN)
    log_user_in(@user)
  end

  should "show a confirmation page" do
    @student = create(:student)
    get students_permanent_delete_path(@student)
    s = assigns(:student)
    assert_not_nil s
    assert_response :success
  end

  should "permanently destroy students" do
    @student = create(:student)
    assert_difference "Student.count", -1 do
      delete students_permanent_delete_path(@student)
      assert_redirected_to students_permanent_delete_index_path(name: @student.name)
    end
  end

end
