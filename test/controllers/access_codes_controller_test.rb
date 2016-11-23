require 'test_helper'

class AccessCodesControllerTest < ActionController::TestCase

  setup do
    @student = create(:student)
    @admin_user = create(:user, role: User::ADMIN)
    log_user_in(@admin_user)
  end

  should "list all codes for this student" do
    create_list(:access_code, 2, student: @student)
    create_list(:access_code, 4, student: @student, expires_at: 2.months.ago)
    create(:access_code)

    get :index, student_id: @student.id
    assert_template :index
    active_access_codes = assigns(:active_access_codes)
    expired_access_codes = assigns(:expired_access_codes)

    assert active_access_codes, "Active Access Codes must be assigned"
    assert expired_access_codes, "Expired access codes must be assigned"

    assert_equal 2, active_access_codes.size, "Only two active access codes for this student"
    assert_equal 4, expired_access_codes.size, "4 Expired codes"

  end


  should "show new form for access_code" do
    get :new, student_id: @student.id
    assert_template :new
  end

  should "show edit form for access_code" do
    code = create(:access_code, student: @student)
    get :edit, student_id: @student.id, id: code.id
    assert_template :edit
  end

  should "create a new access code" do
    assert_difference "AccessCode.count", 1 do
      post :create, student_id: @student.id, access_code: { for: "whaterver", code: "code", expires_at: "2014-10-10" }
      code = assigns(:access_code)
      assert_equal 0, code.errors.size, "There should be no errors"
      assert_equal code.student.id, @student.id, "Student was assigned"
      assert_equal code.created_by.id, @admin_user.id, "Created by was assigned"
      assert_redirected_to student_access_codes_path(@student), "Should redirect back to student access codes list"
    end
  end

  should "remove an existing access code" do
    code = create(:access_code, student: @student)

    assert_difference "AccessCode.count", -1 do
      post :destroy, student_id: @student.id, id: code.id
      assert_redirected_to student_access_codes_path(@student), "Should redirect back to student codes list"
    end
  end

end
