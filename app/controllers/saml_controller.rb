class SamlController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:consume]

  def login
    request = OneLogin::RubySaml::Authrequest.new
    redirect_to(request.create(saml_settings))
  end

  def consume
    response = OneLogin::RubySaml::Response.new(params[:SAMLResponse])
    response.settings = saml_settings
    if response.is_valid?
      session[:userid] = response.nameid
      session[:attributes] = response.attributes
      render json: {}
    else
      render json: response.errors.to_json
    end
  end

  def metadata
    settings = saml_settings
    meta = OneLogin::RubySaml::Metadata.new
    render xml: meta.generate(settings), content_type: 'application/samlmetadata+xml'
  end

  private

  def saml_settings
    settings = OneLogin::RubySaml::Settings.new

    settings.assertion_consumer_service_url = "#{ENV['CALLBACK_DOMAIN']}/saml/consume"
    settings.sp_entity_id = "#{ENV['CALLBACK_DOMAIN']}/saml/metadata"
    settings.idp_sso_service_url = ENV['IDP_SSO_SERVICE_URL']
    settings.idp_cert_fingerprint = ENV['IDP_CERT_FINGERPRINT']

    settings.assertion_consumer_service_binding = 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST'
    settings.name_identifier_format = 'urn:oasis:names:tc:SAML:2.0:nameid-format:emailAddress'
    settings.idp_cert_fingerprint_algorithm = ENV['IDP_CERT_FINGERPRINT-ALGORITHM']

    # # Optional for most SAML IdPs
    settings.authn_context = 'urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport'
    settings
  end
end
