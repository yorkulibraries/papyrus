require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  
  should "FOR PASSPORT YORK: create a new session and log user in if valid user" do
    user = create(:user, username: "someuser")
    
    @request.env['HTTP_PYORK_USER'] = user.username
    
    get :new
    
    assert_not_nil session[:user_id], "session user id should not be nil"
    assert_equal user.id, session[:user_id], "session user id should be set"
    assert_redirected_to root_url, "For regular user go to root url"
  end
  
  should "FOR PASSPORT YORK: redirect Student to student view section if valid student" do
    student = create(:student)
    @request.env['HTTP_PYORK_USER'] = student.username
    
    get :new
    
    assert_equal User::STUDENT_USER, student.role
    assert_equal student.id, session[:user_id], "Session user id is student's id"
    assert_redirected_to student_view_url, "Redirects to student view url"
  end
  
  should "Show invalid login page if user is not found" do
    @request.env["HTTP_PYORK_USER"] = "somecooldude"
    
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
  
  

end
