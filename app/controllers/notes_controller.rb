class NotesController < ApplicationController
  authorize_resource
  before_filter :load_student

  def index
    @notes = @student.notes.includes(:user)
    @note = Note.new
  end

  def create
    @note = @student.notes.build(note_params)
    @note.user = @current_user
    @note.audit_comment = "Added a new note"


    respond_to do |format|
      if @note.save
        format.js
        format.html { redirect_to student_notes_path(@student), notice: "Successfully created note." }
      else
        format.html { render action: 'new' }
        format.js
      end
    end
  end

  def edit
    @note = Note.find(params[:id])

    unless @note.editable_time > Time.now
      redirect_to student_notes_path(@student),  alert: "Time to edit the note has ended."
    end
  end

  def update
    @note = Note.find(params[:id])
    
    unless @note.editable_time > Time.now
        redirect_to student_notes_path(@student),  alert: "Time to edit the note has ended."
    else

      @note.audit_comment = "Updated: #{@note.note}"

      respond_to do |format|

        if @note.update_attributes(note_params)
          format.js
          format.html { redirect_to student_notes_path(@student), notice: "Successfully updated note." }
        else
          format.html { render action: 'edit' }
          format.js
        end
      end
    end

  end

  def destroy
    @note = Note.find(params[:id])
    @note.audit_comment = "Delete a note"
    @note.destroy
    redirect_to student_notes_path(@student), notice: "Successfully destroyed note."
  end

  private
  def load_student
    @student = Student.find(params[:student_id])
  end

  def note_params
    params.require(:note).permit( :note)
  end
end
