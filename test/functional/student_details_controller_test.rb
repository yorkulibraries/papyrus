require 'test_helper'

class StudentDetailsControllerTest < ActionController::TestCase
  setup do
    @manager_user = create(:user, role: User::MANAGER)  
    @student = create(:student)
    log_user_in(@manager_user)
  end
  
  should "show now form" do    
    get :new, student_id: @student.id
    assert_template :new    
  end
  
  should "create a new student details if without student details" do
    student = create(:student, student_details: nil)
    assert_difference "StudentDetails.count", 1 do
      post :create, student_id: student.id, 
                    student_details: attributes_for(:student_details, 
                             transcription_coordinator_id: @manager_user.id, transcription_assistant_id: @manager_user.id ).except(:student)

      details = assigns(:student_details)
      assert_equal 0, details.errors.count, "No errors, #{details.errors.messages}"
      assert_response :redirect, "Should redirect"
      assert_redirected_to student_path(student.id), "Should redirect to student"
    end
        
  end
  
  should "not create student details if there is one already" do
    assert_no_difference "StudentDetails.count" do
      student_details_id = @student.student_details.id
      
      post :create, student_id: @student.id, 
          student_details: attributes_for(:student_details, transcription_coordinator: @manaer_user, transcription_assistant: @manaer_user ).except(:student)      
          
      assert_equal student_details_id, @student.student_details.id
    end
  end
  
  should "show edit page" do
    
    get :edit, student_id: @student.id, id: @student.student_details.id
    
    assert_template :edit
  end
  
  should "update student details" do
    details = create(:student_details, student: @student, campus_phone: "123")
    
    post :update, student_id: @student.id, id: details.id, student_details: { campus_phone: '345'}
    
    details = assigns(:student_details)
    assert_equal 0, details.errors.size, "No errors"
    assert_equal "345", details.campus_phone, "Campus phone should be changed"
    assert_redirected_to student_path(@student), "Redirects to student show page"
    
  end
  
end
