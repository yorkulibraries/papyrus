class AccessCodesController < ApplicationController
  authorize_resource  
  before_filter :load_student
  
  def index
    @active_access_codes = @student.access_codes.active
    @expired_access_codes = @student.access_codes.expired
  end

  def show
    @access_code =  @student.access_codes.find(params[:id])
  end

  def new
    @access_code =  @student.access_codes.new
  end

  def create
    @access_code =  @student.access_codes.new(params[:access_code])
    @access_code.created_by = current_user
    @access_code.audit_comment = "Adding a new access code for #{@access_code.for}"
    
    if @access_code.save
      respond_to do |format|
        format.html { redirect_to student_access_codes_path(@student), notice: "Successfully created access code." }
        format.js
      end
    else
      respond_to do |format|
        format.html { render action: 'new' }
        format.js
      end
    end
  end

  def edit
    @access_code =  @student.access_codes.find(params[:id])
  end

  def update
    @access_code =  @student.access_codes.find(params[:id])
    if @access_code.update_attributes(params[:access_code])
      redirect_to @access_code, notice: "Successfully updated access code."
    else
      render  action: 'edit'
    end
  end

  def destroy
    @access_code =  @student.access_codes.find(params[:id])
    @access_code.destroy
    @access_code.audit_comment = "Removed Access Code For #{@access_code.for}"
    
    respond_to do |format|
      format.html { redirect_to student_access_codes_path(@student), notice: "Successfully destroyed access code." }
      format.js
    end
    
  end
  
  private
  def load_student
    @student = Student.find(params[:student_id])
  end
end