class StudentsController < ApplicationController
  authorize_resource

  def index
     page_number = params[:page] ||= 1

     @students = Student.active.includes(:student_details).page(page_number)
     @current_items_counts = Student.item_counts(@students.collect { |s| s.id }, "current")
  end


  def notify
    if params[:students]
      params[:students].each do |id|
        student = Student.find(id)
        StudentMailer.notification_email(student, current_user, params[:message]).deliver_later
        student.save(validate: false)
      end
      redirect_to item_path(params[:item]),  notice: "Notification Sent" if params[:item]
      redirect_to student_path(params[:student]),  notice: "Message Sent" if params[:student]

    else

      redirect_to item_path(params[:item]),  alert: "No Student was selected" if params[:item]
      redirect_to student_path(params[:student]),  alert: "No Student was selected" if params[:student]

    end


    redirect_to root_url unless params[:item] or params[:student]
  end

  def block
    @student = Student.find(params[:id])
    @student.blocked = true
    @student.audit_comment = "Student blocked by #{@current_user.name}"
    @student.save(validate: false)
    redirect_to @student
  end

  def unblock
   @student = Student.find(params[:id])
   @student.blocked = false
   @student.audit_comment = "Student unblocked by #{@current_user.name}"
   @student.save(:validate => false)
   redirect_to @student
  end

  def search
    page_number = params[:page] ||= 1
    query = params[:q].strip
    inactive_status = params[:inactive].blank? ? false : true
    @searching = true
    @query = query

    @students = Student.where("users.first_name like ? or users.last_name like ? or users.username = ? or users.email like ?",
                              "%#{query}%", "%#{query}%", "#{query}", "%#{query}%")
                        .where(inactive: inactive_status).page page_number



    @current_items_counts = Student.item_counts(@students.collect { |s| s.id }, "current")

    respond_to do |format|
      format.json { render :json => @students.map { |student| {:id => student.id, :name => student.name } } }
      format.html {  render :template => "students/index" }
    end

  end


  def show
    @student = Student.find(params[:id])
    @items = @student.current_items
    @expired_items = @student.expired_items
    @items_grouped = @items.group_by { |i| i.item_type }

    @active_access_codes = @student.access_codes.active
    @shared_codes = AccessCode.shared.active
    @active_access_codes += @shared_codes

    @expired_access_codes = @student.access_codes.expired

    @courses_grouped = @student.courses.group_by { |c| { name: c.term.name, id: c.term.id } }
  end

  def audit_trail
    @student = Student.find(params[:id])
    @audits = @student.audits | @student.associated_audits
    @audits.sort! { |a, b| a.created_at <=> b.created_at }


    @audits_grouped = @audits.reverse.group_by { |a| a.created_at.at_beginning_of_day }

    respond_to do |format|
      format.html
      format.xlsx {
        response.headers['Content-Disposition'] = "attachment; filename=\"#{@student.details.student_number}_audit_trail.xlsx\""
      }

    end
  end


  def new
    @student = Student.new
    @student.build_student_details
  end

  def create
    @student = Student.new(student_params)
    @student.role = "student" # default hidden role
    @student.created_by = @current_user
    @student.audit_comment = "Registered the student"
    @student.student_details.audit_comment = "Saved student details."

    if @student.save
      redirect_to @student, notice: "Successfully registered a student."
    else
      render :action => 'new'
    end
  end

  def send_welcome_email
    @student = Student.find(params[:id])
    @student.audit_comment = "Sending welcome email."
    StudentMailer.welcome_email(@student, current_user).deliver_later
    @student.email_sent_at = Time.zone.now
    @student.save!

    redirect_to @student, notice: "Sent welcome email."
  end

  def complete_orientation
    @student = Student.find(params[:id])
    @student.details.complete_orientation
    redirect_to @student, notice: "Orientation has been completed"
  end

  def edit
    @student = Student.find(params[:id])
  end

  def update
    @student = Student.find(params[:id])
    @student.audit_comment = "Updated the student"
    @student.student_details.audit_comment = "Updated student details."
    if @student.update_attributes(student_params)
      redirect_to @student, notice:  "Successfully updated student."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @student = Student.find(params[:id])
    @student.inactive = true
    @student.audit_comment = "Set Student account to INACTIVE"
    @student.save(validate: false)
    redirect_to @student, notice: "This student's access has been disabled."
  end

  def reactivate
    @student = Student.find(params[:id])
    @student.inactive = false
    @student.audit_comment = "Set Student account to ACTIVE"
    @student.save

    respond_to do |format|
      format.html { redirect_to @student, notice: "Student has been reactivated, and can now use Papyrus" }
      format.js
    end

  end

  ## COURSE ENROLLMENT
  def enroll_in_courses
    @student = Student.find(params[:id])

    course_ids = params[:course_ids]

    course_ids.split(",").each do |id|
      course = Course.find(id)
      course.enroll_student(@student)
    end

    @courses_grouped = @student.courses.group_by { |c| { name: c.term.name, id: c.term.id } }
  end

  def withdraw_from_course
    @student = Student.find(params[:id])
    @course = @student.courses.find(params[:course_id])

    @course.withdraw_student(@student) unless @course.blank?
  end


  private
  def student_params
    params.require(:student).permit( :first_name, :last_name, :name, :email, :username,
          student_details_attributes: [  :student_number, :preferred_phone, :request_form_signed_on,
                           :format_large_print, :format_pdf, :format_kurzweil, :format_daisy, :format_braille, :format_word, :format_note, :format_other,
                           :transcription_coordinator_id, :transcription_assistant_id, :cds_counsellor, :cds_counsellor_email, :book_retrieval,
                           :requires_orientation, :orientation_completed, :orientation_completed_at, :accessibility_lab_access, :alternate_format_required
                                      ]
                                    )
  end
end
