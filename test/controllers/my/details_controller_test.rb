require 'test_helper'

class My::DetailsControllerTest < ActionController::TestCase
  setup do
    @student = create(:student)
    log_user_in(@student)
    session[:terms_accepted] = true
  end

  should "show student details page" do

    get :show

    assert_response :success
    assert assigns(:student_details)
  end




  should "assign review_details variable if review parameter is present" do
    get :show, params: { welcome: true }

    welcome_details = assigns(:welcome_details)
    assert welcome_details == true, "Should be assigned, because we're new"
  end
end
