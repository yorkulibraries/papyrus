class Students::ListController < AuthenticatedController
  before_action do
    authorize! :show, :dashboard
  end

  def never_logged_in
    @students = Student.never_logged_in.includes(:student_details).reject { |s| s.lab_access_only? }
  end

  def inactive
    page_number = params[:page] ||= 1
    @students = Student.inactive.includes(:student_details).page(page_number)
  end

  def blocked
    page_number = params[:page] ||= 1
    @students = Student.blocked.includes(:student_details).page(page_number)
  end
end
