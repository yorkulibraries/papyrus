class Students::ListController < ApplicationController

  before_filter do
    authorize! :show, :dashboard
  end


  def never_logged_in
    @students = Student.never_logged_in.reject { |s| s.lab_access_only? }
  end

  def inactive
    page_number = params[:page] ||= 1
    @students = Student.inactive.page(page_number)
  end

  def blocked
    page_number = params[:page] ||= 1
    @students = Student.blocked.page(page_number)
  end

end
