class Students::ListController < ApplicationController

  before_filter do
    authorize! :show, :dashboard
  end


  def never_logged_in
    page_number = params[:page] ||= 1
    @students = Student.never_logged_in.page(page_number)
  end

  def inactive
    page_number = params[:page] ||= 1
    @students = Student.inactive.page(page_number)
  end
end
