class My::ApiController < ApplicationController

  before_filter :authorize_controller, except: :login_as_student

  def login_as_student
    authorize! :login_as, :student

    @student = Student.find(params[:id])
    if @student
      # ensure that we can get back to whatever we were before
      session[:return_to_user_id] = current_user.id

      # then sign in as student
      session[:user_id] = @student.id

      @student.last_logged_in_at = Time.now
      @student.audit_comment = "#{current_user.name} logged in as this student"
      @student.save(validate: false)

      redirect_to student_view_path, notice: "Logged in as student #{@student.name}"
    else
      redirect_to students_path, error: "No such student found"
    end
  end

  def logout_as_student

    student_id = current_user.id
    session[:terms_accepted]  = nil
    session[:user_id] = session[:return_to_user_id]
    session[:return_to_user_id] = nil
    redirect_to student_path(student_id)
  end

  private
  def authorize_controller
     authorize! :show, :student
  end

  def load_student
    @student = Student.find(current_user.id)
  end

end
