class StudentDetailsController < ApplicationController
  authorize_resource Student
  before_filter :load_student
  
  def new
    @student_details = StudentDetails.new
  end

  def show
    @student_details = @student.details
  end
  
  def create
    @student_details = StudentDetails.new(params[:student_details])   
    @student_details.student = @student
    @student_details.audit_comment = "Created student details"
    if @student_details.save
      redirect_to @student, notice: "Successfully created student details."
    else
      render :action => 'new'
    end
  end

  def edit
    @student_details = @student.student_details || StudentDetails.new   
  end

  def update
    @student_details = @student.student_details
    @student_details.audit_comment = "Updated student details"
    if @student_details.update_attributes(params[:student_details])
      redirect_to student_details_path(@student), notice:  "Successfully updated additional student details."
    else
      render :action => 'edit'
    end
  end

  
  private 
  def load_student
    @student = Student.find(params[:student_id])
  end
end
