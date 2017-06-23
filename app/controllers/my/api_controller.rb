class My::ApiController < My::BaseController

  skip_before_action :check_terms_acceptance
  skip_before_action :authorize_controller, only: :login_as_student
  skip_before_action :load_student, only: [:login_as_student, :logout_as_student]


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

      redirect_to my_terms_path, notice: "Logged in as student #{@student.name}"
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


end
