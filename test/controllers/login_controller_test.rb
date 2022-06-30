require 'test_helper'

class LoginControllerTest < ActionDispatch::IntegrationTest
  context 'headers authentication' do
    setup do
      Rails.configuration.is_using_login_password_authentication = false
      @cas_header = PapyrusSettings.auth_cas_header
      @cas_alt_header = PapyrusSettings.auth_cas_header_alt
      PapyrusSettings.course_sync_on_login = PapyrusSettings::FALSE
    end

    should 'FOR CAS: create a new session and log user in if valid user' do
      user = create(:user, username: 'someuser')

      get login_url, headers: { "#{@cas_header}" => user.username }

      user.reload
      assert Date.today >= user.last_logged_in_at.to_date, 'Logged in date should be set'
      assert_not_nil session[:user_id], 'session user id should not be nil'
      assert_equal user.id, session[:user_id], 'session user id should be set'
      assert_redirected_to root_url, 'For regular user go to root url'
    end

    should 'FOR CAS: redirect Student to student view section if valid student' do
      student = create(:student)

      get login_url, headers: { "#{@cas_header}" => student.username }

      student.reload
      assert Date.today >= student.last_logged_in_at.to_date, 'Logged in date should be set'
      assert_equal User::STUDENT_USER, student.role
      assert_equal student.id, session[:user_id], "Session user id is student's id"
      assert_redirected_to my_student_portal_path, 'Redirects to student view url'
    end

    should 'Show invalid login page if user is not found' do
      get login_url, headers: { "#{@cas_header}" => 'somecooldude' }

      assert_nil session[:user_id], 'Session user id was not set'
      assert_equal 'Invalid email or password', flash[:alert]
    end

    should 'destroy the session when logging out' do
      user = create(:user)
      get login_url, headers: { "#{@cas_header}" => user.username }
      assert_equal user.id, session[:user_id]

      get logout_url

      assert_nil session[:user_id]
      assert_nil session[:terms_accepted]
    end

    should 'check the alternate CAS Header if main CAS Header failed' do
      student = create(:student)

      get login_url, headers: { "#{@cas_alt_header}" => student.username }

      assert_redirected_to my_student_portal_path, 'Redirects to student view url'
      assert_equal student.id, session[:user_id], "Session user id is student's id"
    end

    should 'only lookup users who are not blocked' do
      blocked = create(:user, blocked: true)

      get login_url, headers: { "#{@cas_alt_header}" => blocked.username }

      assert_nil session[:user_id], 'Session user id was not set'
      assert_equal 'Invalid email or password', flash[:alert]
    end

    should "update username with alt_username if username and alt_username don't match" do
    end
  end

  context 'Login and password authentication' do
    setup do
      Rails.configuration.is_using_login_password_authentication = true
      @user = create(:user, username: 'someuser', password: '12345678')
      get login_path
    end

    should 'User creation and login in' do
      assert_response :success
      post login_path, params: { email: @user.email, password: '12345678' }
      assert_equal 'Logged in!', flash[:notice]
      assert_response :redirect
    end

    should 'invalid login in' do
      assert_response :success
      post login_path, params: { email: @user.email, password: '12345679' }
      assert_equal 'Logged in!', flash[:notice]
      assert_response :redirect
    end
  end
end
