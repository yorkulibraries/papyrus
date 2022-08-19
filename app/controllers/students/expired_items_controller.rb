class Students::ExpiredItemsController < AuthenticatedController
  before_action :load_student

  def show
    @expired_items = @student.expired_items
  end

  private

  def load_student
    @student = Student.find(params[:student_id])
    authorize! :update, @student
  end
end
