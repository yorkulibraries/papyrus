class Students::LabAccessOnlyController < ApplicationController
  before_filter do
    authorize! :show, :dashboard
  end

  def show
    page_number = params[:page] ||= 1
    @students = Student.lab_access_only.page(page_number)
  end

  def destroy

    Student.lab_access_only.each do |student|      
      student.inactive = true
      student.audit_comment = "Disabled access by #{@current_user.name}, via mass Lab Access Only Disable function"
      student.save(validate: false)
    end

    redirect_to students_lab_access_only_path, notice: "Diabled access for all Lab Access Only Students"
  end
end
