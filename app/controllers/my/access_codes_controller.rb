class My::AccessCodesController < ApplicationController
  
  before_filter :authorize_controller, :load_student, :check_terms_acceptance

  def show

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
