require 'test_helper'
require 'webmock/minitest'

class SamlControllerTest < ActionDispatch::IntegrationTest
  context 'Sending values for authentication' do
    setup do
      get login_sam_path
    end

    should 'setting initial values' do
      assert_match(%r{https://.+}, ENV['IDP_SSO_SERVICE_URL'])
      assert_match(/www.w3.org/, ENV['IDP_CERT_FINGERPRINT-ALGORITHM'])
      assert_match(/([A-F]|[0-9]){2}(:([A-F]|[0-9]){2}){31}/, ENV['IDP_CERT_FINGERPRINT'])
    end

    should 'sign in with saml' do
      assert_response :redirect
      assert_match(/\?SAMLRequest=/, response.body)
    end
  end

  context 'Retriving values from external provider' do
    setup do
      post '/saml/consume', params: { SAMLResponse: File.open('test/fixtures/saml_token.txt').read }
    end

    should 'decode response from external provider' do
      # "SAMLResponse"=>"
    end
  end
end
