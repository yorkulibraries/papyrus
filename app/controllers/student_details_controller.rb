class StudentDetailsController < AuthenticatedController
  authorize_resource Student
  before_action :load_student

  def new
    @student_details = StudentDetails.new
  end

  def show
    @student_details = @student.details
  end

  def create
    @student_details = StudentDetails.new(student_details_params)
    @student_details.student = @student
    @student_details.audit_comment = 'Created student details'
    if @student_details.save
      redirect_to @student, notice: 'Successfully created student details.'
    else
      render action: 'new'
    end
  end

  def edit
    @student_details = @student.student_details || StudentDetails.new
  end

  def update
    @student_details = @student.student_details
    @student_details.audit_comment = 'Updated student details'
    if @student_details.update(student_details_params)
      redirect_to student_details_path(@student), notice: 'Successfully updated additional student details.'
    else
      render action: 'edit'
    end
  end

  private

  def load_student
    @student = Student.find(params[:student_id])
  end

  def student_details_params
    params.require(:student_details).permit(:student_number, :preferred_phone, :request_form_signed_on,
                                            :format_large_print, :format_pdf, :format_kurzweil, :format_epub, :format_daisy, :format_braille, :format_word, :format_note, :format_other,
                                            :transcription_coordinator_id, :transcription_assistant_id, :cds_counsellor, :cds_counsellor_email, :book_retrieval,
                                            :requires_orientation, :orientation_completed, :orientation_completed_at, :accessibility_lab_access, :alternate_format_required)
  end
end
