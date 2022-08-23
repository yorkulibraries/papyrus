# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    class BaseControllerTest < ActionDispatch::IntegrationTest
      should 'redirect to info url if API is disabled' do
        PapyrusSettings.api_enable = PapyrusSettings::FALSE
        get api_v1_login_test_path
        assert_redirected_to api_v1_info_path(disabled: true)
      end

      should 'not redirect to info page if API is enabled' do
        PapyrusSettings.api_enable = PapyrusSettings::TRUE
        PapyrusSettings.api_http_auth_enable = PapyrusSettings::FALSE
        get api_v1_login_test_path
        assert_response :success
      end

      should 'ask for login if http_auth is enabled' do
        PapyrusSettings.api_enable = PapyrusSettings::TRUE
        PapyrusSettings.api_http_auth_enable = PapyrusSettings::TRUE

        get api_v1_login_test_path
        assert_response 401, 'Should denied'
      end

      should 'log in and not redirect if right credentials were passed' do
        PapyrusSettings.api_enable = PapyrusSettings::TRUE
        PapyrusSettings.api_http_auth_enable = PapyrusSettings::TRUE

        user = PapyrusSettings.api_http_auth_user
        pw = PapyrusSettings.api_http_auth_pass

        basic = ActionController::HttpAuthentication::Basic
        @credentials = basic.encode_credentials(user, pw)

        #
        # TODO: THIS NEEDS TO BE TESTED
        # get :test
        # get api_v1_login_test_path, headers: { "Accept" => "application/json", "Authorization" => @credentials}
        # assert_response :success
      end
    end
  end
end
