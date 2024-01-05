# frozen_string_literal: true

class LoginController < ApplicationController
  def new
    return unless Rails.configuration.is_authentication_method == :header

    username = request.headers[PapyrusSettings.auth_cas_header]
    alt_username = request.headers[PapyrusSettings.auth_cas_header_alt]
    user = User.unblocked.find_by('username = ? OR username = ?', username, alt_username)

    if user.present?
      session[:user_id] = user.id
      session[:username] = user.name
      user.active_now!(User::ACTIVITY_LOGIN)

      if user.role == User::STUDENT_USER
        redirect_to my_student_portal_path
      else
        redirect_to root_url, notice: 'Logged in!'
      end
    else
      flash.now.alert = 'Invalid email or password'
      render layout: 'simple'
    end
  end

  def destroy
    cookies.delete('mayaauth', domain: PapyrusSettings.auth_cookies_domain)
    cookies.delete('pybpp', domain: PapyrusSettings.auth_cookies_domain)
    reset_session
    redirect_to PapyrusSettings.auth_cas_logout_redirect, allow_other_host: true
  end

  def create
    user = User.find_by_email(params[:email])
    if Rails.configuration.is_authentication_method == :devise && user && user.valid_password?(params[:password])
      session[:user_id] = user.id
      redirect_to root_url, notice: 'Logged in!'
    else
      redirect_to login_url, notice: 'Email or password is invalid'
    end
  end

end
