class My::TermsController < ApplicationController

  before_filter :authorize_controller, :load_student

  def show

  end

  def update
    session[:terms_accepted] = true
    redirect_to my_items_path
  end

  private
  def authorize_controller
     authorize! :show, :student
  end

  def load_student
    @student = Student.find(current_user.id)
  end

end
