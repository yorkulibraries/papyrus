class StudentViewController < ApplicationController
  
  before_filter :authorize_controller, :load_student, :except => :login_as_student
  
  def index
    
  end

  def accept_terms  
     session[:terms_accepted] = true
     redirect_to student_view_path
  end

  def show    
    redirect_to show_student_terms_path unless session[:terms_accepted]        
    
    @items = @student.current_items
    @courses = @items.map {|i| i.courses }.flatten.map{ |c| short_name(c.code)}.uniq
    
    @courses_grouped = @courses.group_by { |c| c.split(" ").first }
    
    if params[:course].present?
      course_chuncks = params[:course].split("_")
      i = @items.joins(:courses).group('items.id').where("courses.code LIKE '%_#{course_chuncks[0]}_%_%#{course_chuncks[1]}_%'")   
      @items_grouped = i.group_by { |i| i.item_type }   
    else
      @items_grouped = @items.group_by { |i| i.item_type }
    end       
   
  end


  def details
    @student_details = @student.student_details
  end

  
  def login_as_student
    authorize! :login_as, :student
    
    @student = Student.find(params[:id])
    if @student
      # ensure that we can get back to whatever we were before
      session[:return_to_user_id] = current_user.id
      
      # then sign in as student
      session[:user_id] = @student.id
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
  
  def short_name(code)
     if code
       chunks = code.split("_")
       return "#{chunks[2]} #{chunks[4]}"
     else
       return code
     end
   end
end
