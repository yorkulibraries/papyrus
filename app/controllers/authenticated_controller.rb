# frozen_string_literal: true

class AuthenticatedController < ApplicationController
  protect_from_forgery
  check_authorization

  before_action :login_required

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]

    # record active stamp if hasn't been updated in the last 5 minutes
    if !@current_user.nil? && (@current_user.last_active_at.nil? || @current_user.last_active_at < 5.minutes.ago)
      @current_user.active_now!
    end

    @current_user
  end
  helper_method :current_user

  def logged_in?
    current_user
  end

  def login_required
    unless logged_in?
      store_target_location
      redirect_to login_url, alert: 'You must first log in or sign up before accessing this page.'
    end
  end

  def redirect_to_target_or_default(default, *args)
    redirect_to(session[:return_to] || default, *args)
    session[:return_to] = nil
  end

  private

  def store_target_location
    session[:return_to] = request.url
  end

  rescue_from CanCan::AccessDenied do |_exception|
    if current_user && current_user.role == User::STUDENT_USER
      redirect_to my_terms_path, notice: 'Access Denied'
    else
      redirect_to root_url, notice: 'Access Denied'
    end
  end
end
