# frozen_string_literal: true

class Students::LabAccessOnlyController < AuthenticatedController
  before_action do
    authorize! :show, :dashboard
  end

  def show
    page_number = params[:page] ||= 1
    @students = Student.lab_access_only.includes(:student_details).page(page_number)
  end

  def destroy
    Student.lab_access_only.each do |student|
      student.blocked = true
      student.audit_comment = "Disabled access for #{@current_user.name}, via mass Lab Access Only Disable function"
      student.save(validate: false)
    end

    redirect_to students_lab_access_only_path, notice: 'Diabled access for all Lab Access Only Students'
  end
end
