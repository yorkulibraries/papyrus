class Api::V1::BaseController < ApplicationController
  skip_authorization_check ## skip authorization, this will use it's own
  skip_before_filter :login_required

  ## BASE CONTROLLER REQUIRING AUTHENTICATION - BASIC HTTP
  ## IT CHECKS IF API ACCESS IS ENABLED

  REALM = "SuperSecret"
  USERS = {"api" => "secret", #plain text password
            "dap" => Digest::MD5.hexdigest(["dap",REALM,"secret"].join(":")) }  #ha1 digest password

  #before_action :authenticate, except: [:info]

  def info
  end

  def test
    render plain: "I'm only accessible if you know the password"
  end

  private
  def authenticate
    authenticate_or_request_with_http_digest(REALM) do |username|
      USERS[username]
    end
  end
end
