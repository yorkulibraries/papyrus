require 'test_helper'

class My::TermsControllerTest < ActionController::TestCase

  setup do
    @student = create(:student)
    log_user_in(@student)
  end

  should "show terms page" do
    get :show
    assert_response :success
    assert_template :show
  end

  should "accept terms and redirect to items page" do
    post :update

    assert  session[:terms_accepted], "Should be accepted terms"

    assert_redirected_to my_items_path
  end

end
