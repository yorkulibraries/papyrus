class SessionsController < ApplicationController
  skip_authorization_check


  def new

    if Rails.env.development?
        if params[:as].nil?
          username = User::ADMIN
        else
          username = params[:as]
        end
    else
       username = request.headers[PapyrusConfig.authentication.cas_header_name]
    end


    user = User.active.find_by_username(username)
    if user
      session[:user_id] = user.id

      user.active_now!(User::ACTIVITY_LOGIN)

      if user.role == User::STUDENT_USER
        redirect_to student_view_path
      else
        redirect_to root_url, :notice => "Logged in!"
      end
    else
      flash.now.alert = "Invalid email or password"

      render :layout => "simple"
    end
  end

  def destroy
    session[:user_id] = nil
    session[:terms_accepted] = nil
    cookies.delete("mayaauth", :domain => PapyrusConfig.authentication.cookies_domain)
    cookies.delete("pybpp", :domain => PapyrusConfig.authentication.cookies_domain)

    redirect_to PapyrusConfig.authentication.after_logout_redirect_to || "http://www.google.ca"
  end



end
