class NotesController < AuthenticatedController
  authorize_resource
  before_action :load_student

  def index
    @notes = @student.notes.includes(:user)
    @note = Note.new
  end

  def create
    @note = @student.notes.build(note_params)
    @note.user = @current_user
    @note.audit_comment = 'Added a new note'

    respond_to do |format|
      if @note.save
        format.js
        format.html { redirect_to student_notes_path(@student), notice: 'Successfully created note.' }
      else
        format.html { render action: 'new' }
        format.js
      end
    end
  end

  def edit
    @note = Note.find(params[:id])

    unless @note.editable_time > Time.now
      redirect_to student_notes_path(@student), alert: 'Time to edit the note has ended.'
    end
  end

  def update
    @note = Note.find(params[:id])

    if @note.editable_time > Time.now

      @note.audit_comment = "Updated: #{@note.note}"

      respond_to do |format|
        if @note.update(note_params)
          format.js
          format.html { redirect_to student_notes_path(@student), notice: 'Successfully updated note.' }
        else
          format.html { render action: 'edit' }
          format.js
        end
      end
    else
      redirect_to student_notes_path(@student), alert: 'Time to edit the note has ended.'
    end
  end

  def destroy
    @note = Note.find(params[:id])
    @note.audit_comment = 'Deleted a note'
    @note.destroy

    respond_to do |format|
      format.html { redirect_to student_notes_path(@student), notice: 'Successfully removed note.' }
      format.js
    end
  end

  private

  def load_student
    @student = Student.find(params[:student_id])
  end

  def note_params
    params.require(:note).permit(:note)
  end
end
