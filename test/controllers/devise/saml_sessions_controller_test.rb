require "test_helper"

class SamlSessionsController < ActionDispatch::IntegrationTest
  context "Sending values for authentication" do
    setup do
      get new_saml_user_session_path
    end

    should "setting initial values" do
      assert_match(%r{https://}, ENV["IDP_SSO_SERVICE_URL"])
      assert_match(/www.w3.org/, ENV["IDP_CERT_FINGERPRINT-ALGORITHM"])
      assert_match(/([A-F]|[0-9]){2}(:([A-F]|[0-9]){2}){31}/, ENV["IDP_CERT_FINGERPRINT"])
    end

    should "sign in with saml" do
      assert_response :redirect
      assert_match(/\?SAMLRequest=/, response.body)
    end
  end
end
