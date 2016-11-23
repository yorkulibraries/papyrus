class My::DetailsController < ApplicationController

  before_filter :authorize_controller, :load_student, :check_terms_acceptance

  def show
    @student_details = @student.student_details

    @username = request.headers[PapyrusSettings.auth_cas_header]
    @alt_username = request.headers[PapyrusSettings.auth_cas_header_alt]
    @courses = request.headers[PapyrusSettings.course_listing_header]
  end

  private
  def authorize_controller
     authorize! :show, :student
  end

  def load_student
    @student = Student.find(current_user.id)
  end

  def check_terms_acceptance
    redirect_to my_terms_path unless session[:terms_accepted]
  end
end
