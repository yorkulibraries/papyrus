require 'test_helper'

class Api::V1::BaseControllerTest < ActionController::TestCase

  should "redirect to info url if API is disabled" do
    PapyrusSettings.api_enable = PapyrusSettings::FALSE
    get :test
    assert_redirected_to api_v1_info_path(disabled: true)
  end

  should "not redirect to info page if API is enabled" do
    PapyrusSettings.api_enable = PapyrusSettings::TRUE
    PapyrusSettings.api_http_auth_enable = PapyrusSettings::FALSE
    get :test
    assert_response :success
  end

  should "ask for login if http_auth is enabled" do
    PapyrusSettings.api_enable = PapyrusSettings::TRUE
    PapyrusSettings.api_http_auth_enable = PapyrusSettings::TRUE

    get :test
    assert_response 401, "Should denied"
  end

  should "log in and not redirect if right credentials were passed" do
    PapyrusSettings.api_enable = PapyrusSettings::TRUE
    PapyrusSettings.api_http_auth_enable = PapyrusSettings::TRUE

    user = PapyrusSettings.api_http_auth_user
    pw = PapyrusSettings.api_http_auth_pass
    #request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)

    basic = ActionController::HttpAuthentication::Basic
    @credentials = basic.encode_credentials(user, pw)
    request.headers['Accept'] = 'application/json'
    request.headers['Authorization'] = @credentials
    #
    # TODO: THIS NEEDS TO BE TESTED
    # get :test
    # assert_response :success
  end

end
