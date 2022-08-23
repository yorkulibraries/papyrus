# frozen_string_literal: true

require 'test_helper'

module Students
  class ListControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = create(:user, role: User::ADMIN)
      log_user_in(@user)
    end

    should 'list never logged in students' do
      details = create(:student_details, format_pdf: true)
      create(:student, last_logged_in_at: nil, student_details: details)
      create_list(:student, 3, last_logged_in_at: 3.days.ago)

      get students_never_logged_in_path
      students = assigns(:students)
      assert_equal 1, students.size, 'Should be 1 never logged in student'
      assert_template :never_logged_in
    end

    should 'list inactive in students' do
      create_list(:student, 2, inactive: false)
      create_list(:student, 5, inactive: true)

      get students_inactive_path
      students = assigns(:students)
      assert_equal 5, students.size, 'There should be 5 inactive students'
    end

    should 'list blocked in students' do
      create_list(:student, 2, blocked: false)
      create_list(:student, 5, blocked: true)

      get students_blocked_path
      students = assigns(:students)
      assert_equal 5, students.blocked.size, 'There should be 5 blocked students'
    end
  end
end
