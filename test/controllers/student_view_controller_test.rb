require 'test_helper'

class StudentViewControllerTest < ActionController::TestCase
  
  context "as student" do
    setup do
      @student = create(:student)
      log_user_in(@student)
    end
  
    should "get index" do
      get :index
      assert_response :success
      assert_template :index
    end
    
    should "show student details page" do
      get :details
      
      assert_response :success
      assert assigns(:student_details)
    end
    
    should "redirect back to index (terms) page if terms are not accepted" do
      get :show
      
      assert_response :redirect
      assert_redirected_to show_student_terms_url
    
    end
    
    
    should "get show temlate if user accepted terms" do
       session[:terms_accepted] = true
       get :show
       assert_response :success
       assert_template :show
    end

    should "only show current items" do
      create_list(:item_connection, 3, student:  @student, :expires_on => Date.today - 1.year)
      create_list(:item_connection, 6, student:  @student, :expires_on => Date.today + 1.year)
      
      session[:terms_accepted] = true
      get :show
      
      items = assigns(:items)
      assert items
      assert_equal 6, items.size
      
    end

  end
  
  context "as logged in user" do
    setup do
      @user = create(:user, role: User::MANAGER)
      log_user_in(@user)
    end
    
    should "be able to log in as student" do
      student = create(:student)
      get :login_as_student, id: student.id
      
      assert_equal student.id, session[:user_id]
      assert_equal @user.id, session[:return_to_user_id]
      assert_response :redirect
      assert_redirected_to student_view_path
    end
    
    should "raises error if log in as student not found" do
      assert_raises ActiveRecord::RecordNotFound do
        get :login_as_student, id: "999"
      end
    end
    
    should "log out as student" do
      student = create(:student)
      
      session[:user_id] = student.id
      session[:return_to_user_id] = @user.id
      session[:terms_accepted] = false
      
      get :logout_as_student
      
      assert_equal nil, session[:return_to_user_id]
      assert_equal @user.id, session[:user_id]
      assert_equal nil, session[:terms_accepted]
      
      assert_response :redirect
      assert_redirected_to student_path(student)
    end
  end
  
  
  
end
