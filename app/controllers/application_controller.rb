class ApplicationController < ActionController::Base
  protect_from_forgery

  #before_action :miniprofiler

  private

  # def miniprofiler
  #   if PapyrusSettings.profiler_enable == PapyrusSettings::TRUE && (current_user && current_user.role != User::STUDENT_USER)
  #     Rack::MiniProfiler.authorize_request
  #   else
  #     Rack::MiniProfiler.deauthorize_request
  #   end
  # end

end
