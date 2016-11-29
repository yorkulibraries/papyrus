require 'test_helper'

class My::BaseControllerTest < ActionController::TestCase

  setup do
    @cas_header = PapyrusSettings.auth_cas_header
    @student = create(:student)
    log_user_in(@student)
    PapyrusSettings.course_sync_on_login = PapyrusSettings::FALSE
  end

  should "redirect to details welcome page if student never logged in" do
    @student.last_logged_in_at = nil
    @student.save

    get :welcome

    assert_redirected_to my_details_path(welcome: true), "Should redirect to my_details_path"
  end

  should "redirect to terms page if student has logged in before" do

    @student.last_logged_in_at = 2.days.ago
    @student.save

    get :welcome

    assert_redirected_to my_items_path, "SHould go to items path"
  end

  should "redirect to sync_courses_path first, if course_sync is enabled" do
    PapyrusSettings.course_sync_on_login = PapyrusSettings::TRUE
    session[:courses_synced] = nil

    get :welcome
    assert session[:courses_synced], "Session should be set"
    assert_redirected_to sync_courses_path
  end

  should "redirect to my_terms if session courses_synced is already set and user is not logged in" do
    PapyrusSettings.course_sync_on_login = PapyrusSettings::TRUE
    session[:courses_synced] = true

    @student.last_logged_in_at = 2.days.ago
    @student.save

    get :welcome

    assert_redirected_to my_items_path, "SHould go to items path"

  end


end
