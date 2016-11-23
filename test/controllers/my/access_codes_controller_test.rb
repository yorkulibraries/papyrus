require 'test_helper'

class My::AccessCodesControllerTest < ActionController::TestCase
  setup do
    @student = create(:student)
    log_user_in(@student)
  end

  should "show access codes page" do
    session[:terms_accepted] = true
    get :show

    assert_response :success
    assert assigns(:student)
  end

  should "redirect to terms page if terms not accepted" do
    get :show

    assert_redirected_to my_terms_path
  end

end
