# frozen_string_literal: true

class Students::PermanentDeleteController < AuthenticatedController
  before_action do
    authorize! :perma_destroy, :student
  end

  def index; end

  def show
    @student = Student.find(params[:id])
  end

  def destroy
    @student = Student.find(params[:id])
    student_name = @student.name
    @student.destroy

    redirect_to students_permanent_delete_index_path(name: student_name), notice: 'Permanently Removed Student Record'
  end
end
