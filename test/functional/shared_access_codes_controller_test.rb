require 'test_helper'

class SharedAccessCodesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
