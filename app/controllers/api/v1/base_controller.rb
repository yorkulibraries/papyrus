class Api::V1::BaseController < ApplicationController
  # skip_authorization_check ## skip authorization, this will use it's own
  # skip_before_filter :login_required

  ## BASE CONTROLLER REQUIRING AUTHENTICATION - BASIC HTTP
  ## IT CHECKS IF API ACCESS IS ENABLED

  before_action :authenticate, except: [:info]

  def info
    @disabled = params[:disabled]
  end

  def test
    render plain: "I'm only accessible if you know the password"
  end

  private

  def authenticate
    @realm = 'Papyrus API v1.0'

    users = { PapyrusSettings.api_http_auth_user => PapyrusSettings.api_http_auth_pass }

    if PapyrusSettings.api_enable == PapyrusSettings::TRUE

      if PapyrusSettings.api_http_auth_enable == PapyrusSettings::TRUE

        authenticate_or_request_with_http_digest(@realm) do |username|
          users[username]
        end

      end

    else
      redirect_to api_v1_info_url(disabled: true)
    end
  end
end
