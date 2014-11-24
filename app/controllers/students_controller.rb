class StudentsController < ApplicationController
  authorize_resource

  def index
     page_number = params[:page] ||= 1

     @students = Student.active.page(page_number)
     @current_items_counts = Student.item_counts(@students.collect { |s| s.id }, "current")
  end

  def inactive
    page_number = params[:page] ||= 1

    @students = Student.inactive.page(page_number)
  end

  def notify
    if params[:students]
      params[:students].each do |id|
        student = Student.find(id)
        StudentMailer.notification_email(student, current_user, params[:message]).deliver
        student.audit_comment = "Sent notification email"
        student.save!
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
    @student.save(:validate => false)
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

    @students = Student.where{
      { first_name.matches => "%#{query}%"} |
      { last_name.matches => "%#{query}%"} | 
      { username.matches => "#{query}"} |
      { email.matches => "%#{query}%"}  }
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
    @items_grouped = @items.group_by { |i| i.item_type }
  end

  def audit_trail
    @student = Student.find(params[:id])
    @audits = @student.audits | @student.associated_audits
    @audits.sort! { |a, b| a.created_at <=> b.created_at }


    @audits_grouped = @audits.reverse.group_by { |a| a.created_at.at_beginning_of_day }
  end


  def new
    @student = Student.new
    @student.build_student_details
  end

  def create
    @student = Student.new(params[:student])
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
    @student.audit_comment = "Sent welcome email."
    StudentMailer.welcome_email(@student, current_user).deliver
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
    if @student.update_attributes(params[:student])
      redirect_to @student, notice:  "Successfully updated student."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @student = Student.find(params[:id])
    @student.inactive = true
    @student.save(validate: false)
    redirect_to @student, notice: "This student's access has been disabled."
  end

  def reactivate
    @student = Student.find(params[:id])
    @student.inactive = false
    @student.save
    redirect_to @student, notice: "Student has been reactivated, and can now use Papyrus"
  end
end
