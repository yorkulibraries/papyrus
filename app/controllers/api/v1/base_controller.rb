class Api::V1::BaseController < ApplicationController
  skip_authorization_check ## skip authorization, this will use it's own

  ## BASE CONTROLLER REQUIRING AUTHENTICATION - BASIC HTTP
  ## IT CHECKS IF API ACCESS IS ENABLED

  REALM = "SuperSecret"
  USERS = {"api" => "secret", #plain text password
            "dap" => Digest::MD5.hexdigest(["dap",REALM,"secret"].join(":")) }  #ha1 digest password

  before_action :authenticate, except: [:index]

  def index
    render plain: "Papyrus REST API version 1.0"
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
