require 'test_helper'

class StudentDetailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @manager_user = create(:user, role: User::MANAGER)
    @student = create(:student)
    log_user_in(@manager_user)
  end

  should 'show now form' do
    get new_student_details_path(@student)
    assert_response :success
  end

  should 'not create student details if there is one already' do
    assert_no_difference 'StudentDetails.count' do
      student_details_id = @student.student_details.id

      post student_details_path(@student), params: {
        student_details: attributes_for(:student_details, transcription_coordinator: @manaer_user, transcription_assistant: @manaer_user).except(:student)
      }

      assert_equal student_details_id, @student.student_details.id
    end
  end

  should 'show edit page' do
    get edit_student_details_path(@student, @student.student_details)

    assert_response :success
  end

  should 'update student details' do
    details = create(:student_details, student: @student, preferred_phone: '123')

    patch student_details_path(@student, details), params: { student_details: { preferred_phone: '345' } }

    details = assigns(:student_details)
    assert_equal 0, details.errors.size, 'No errors'
    assert_equal '345', details.preferred_phone, 'preferred_phone should be changed'
    assert_redirected_to student_details_path(@student), 'Redirects to student details page'
  end
end
