require 'test_helper'

class My::DetailsControllerTest < ActionController::TestCase
  setup do
    @student = create(:student)
    log_user_in(@student)
  end

  should "show student details page" do
    session[:terms_accepted] = true
    get :show

    assert_response :success
    assert assigns(:student_details)
  end

  should "redirect to terms page if terms not accepted" do
    get :show

    assert_redirected_to my_terms_path
  end

end
