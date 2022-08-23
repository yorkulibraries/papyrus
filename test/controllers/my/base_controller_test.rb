# frozen_string_literal: true

require 'test_helper'

module My
  class BaseControllerTest < ActionDispatch::IntegrationTest
    setup do
      @cas_header = PapyrusSettings.auth_cas_header
      @student = create(:student)
      log_user_in(@student)
      PapyrusSettings.course_sync_on_login = PapyrusSettings::FALSE
    end

    should 'redirect to details welcome page if student never logged in' do
      @student.first_time_login = true
      @student.save(validate: false)

      get my_student_portal_path
      assert_redirected_to my_details_path(welcome: true), 'Should redirect to my_details_path'

      @student.reload
      assert_equal false, @student.first_time_login?, 'First time login should be set to false'
    end

    should 'redirect to terms page if student has logged in before' do
      @student.last_logged_in_at = 2.days.ago
      @student.save

      get my_student_portal_path

      assert_redirected_to my_items_path, 'SHould go to items path'
    end

    should 'redirect to sync_courses_path first, if course_sync is enabled' do
      PapyrusSettings.course_sync_on_login = PapyrusSettings::TRUE
      session[:courses_synced] = nil

      get my_student_portal_path
      assert session[:courses_synced], 'Session should be set'
      assert_redirected_to my_sync_courses_path
    end

    should 'redirect to my_terms if session courses_synced is already set and user is not logged in' do
      PapyrusSettings.course_sync_on_login = PapyrusSettings::TRUE
      # session[:courses_synced] = true

      get my_student_portal_path
      assert session[:courses_synced], 'Session should be set'
      assert_redirected_to my_sync_courses_path

      @student.last_logged_in_at = 2.days.ago
      @student.save

      get my_student_portal_path

      assert_redirected_to my_items_path, 'SHould go to items path'
    end
  end
end
