class Students::BulkRenewItemsController < AuthenticatedController
  before_action :load_student

  def new
    @items = @student.items
  end

  def create
    @items = @student.items
    date = params[:expires_on][:date] if params[:expires_on]

    @items.each do |i|
      i.assign_to_student(@student, date)
    end

    if date.blank?
      message = "All items Never expire"
    else
      message = "All items now expire on #{Date.parse(date).strftime("%b %d, %Y")}"
    end

    redirect_to student_path(@student), notice: message
  end

  private
  def load_student
    @student = Student.find(params[:student_id])
    authorize! :update, @student
  end
end
