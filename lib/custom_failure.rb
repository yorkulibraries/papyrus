# frozen_string_literal: true

class CustomFailure < Devise::FailureApp
  def redirect_url
    new_user_session_url(subdomain: 'secure')
  end

  # You need to override respond to eliminate recall
  def respond
    # byebug
    if attempted_path == saml_user_session_path
      redirect_to '/'
    else
      super
    end
  end
end
