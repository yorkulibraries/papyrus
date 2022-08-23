# frozen_string_literal: true

require 'test_helper'

module Students
  class LabAccessOnlyControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = create(:user, role: User::ADMIN)
      log_user_in(@user)
    end

    should 'list students that have no format field filled out' do
      details = build(:student_details, format_pdf: true)
      create(:student, student_details: details)
      create_list(:student, 3)

      get students_lab_access_only_path
      students = assigns(:students)
      assert_equal 3, students.size, 'Should be 3 lab access only students'
      assert_template :show
    end

    should 'Disable all students that have no format filled out' do
      create_list(:student, 3, blocked: false)

      assert_equal 3, Student.lab_access_only.unblocked.size, 'Should be 3 active'
      delete students_lab_access_only_path
      assert_redirected_to students_lab_access_only_path

      assert_equal 3, Student.lab_access_only.blocked.size, 'Should be 3 inactive'
    end
  end
end
