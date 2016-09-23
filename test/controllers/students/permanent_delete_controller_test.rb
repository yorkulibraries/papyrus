require 'test_helper'

class Students::PermanentDeleteControllerTest < ActionController::TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get destroy" do
    get :destroy
    assert_response :success
  end

end
