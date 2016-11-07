require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  setup do
    @cas_header = PapyrusSettings.auth_cas_header
    @cas_alt_header = PapyrusSettings.auth_cas_header_alt
    PapyrusSettings.course_sync_on_login = PapyrusSettings::FALSE

  end
  should "FOR CAS: create a new session and log user in if valid user" do
    user = create(:user, username: "someuser")

    @request.env[@cas_header] = user.username

    get :new

    user.reload
    assert Date.today >= user.last_logged_in_at.to_date, "Logged in date should be set"
    assert_not_nil session[:user_id], "session user id should not be nil"
    assert_equal user.id, session[:user_id], "session user id should be set"
    assert_redirected_to root_url, "For regular user go to root url"
  end

  should "FOR CAS: redirect Student to student view section if valid student" do
    student = create(:student)
    @request.env[@cas_header] = student.username

    get :new

    student.reload
    assert Date.today >= student.last_logged_in_at.to_date, "Logged in date should be set"
    assert_equal User::STUDENT_USER, student.role
    assert_equal student.id, session[:user_id], "Session user id is student's id"
    assert_redirected_to student_view_url, "Redirects to student view url"
  end

  should "redirect to sync_courses_path first, if course_sync is enabled" do
    PapyrusSettings.course_sync_on_login = PapyrusSettings::TRUE
    student = create(:student)
    @request.env[@cas_header] = student.username

    get :new
    assert_redirected_to sync_courses_path
  end

  should "Show invalid login page if user is not found" do
    @request.env[@cas_header] = "somecooldude"

    get :new
    assert_nil session[:user_id], "Session user id was not set"
    assert_template "new"
    assert_equal "Invalid email or password", flash[:alert]
  end

  should "destroy the session when logging out" do
    session[:user_id] = 12
    session[:terms_accepted] = "true"
    @request.cookies["mayaauth"] = { value: "mayaauth", domain: "yorku.ca"}
    @request.cookies["pybpp"] = { value: "pybpp", domain: "yorku.ca"}

    get :destroy

    assert_nil session[:user_id]
    assert_nil session[:terms_accepted]
    assert_nil cookies["mayaauth"], "Cookies #{cookies["myayauth"].inspect}"
    assert_nil cookies["pybpp"], "Cookies #{cookies["myayauth"].inspect}"

  end

  should "check the alternate CAS Header if main CAS Header failed" do
    student = create(:student)
    @request.env[@cas_alt_header] = student.username

    get :new

    assert_redirected_to student_view_url, "Redirects to student view url"
    assert_equal student.id, session[:user_id], "Session user id is student's id"


  end



end
