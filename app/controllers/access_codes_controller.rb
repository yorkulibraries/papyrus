# frozen_string_literal: true

class AccessCodesController < AuthenticatedController
  authorize_resource
  before_action :load_student

  def index
    @active_access_codes = @student.access_codes.active
    @shared_codes = AccessCode.shared.active
    @active_access_codes += @shared_codes

    @expired_access_codes = @student.access_codes.expired
  end

  def show
    @access_code =  @student.access_codes.find(params[:id])
  end

  def new
    @access_code =  @student.access_codes.new
  end

  def create
    @access_code =  @student.access_codes.new(access_code_params)
    @access_code.created_by = current_user
    @access_code.audit_comment = "Adding a new access code for #{@access_code.for}"

    if @access_code.save
      respond_to do |format|
        format.html { redirect_to student_access_codes_path(@student), notice: 'Successfully created access code.' }
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
    @access_code.audit_comment = 'Updating access code information'

    if @access_code.update(access_code_params)
      redirect_to @access_code, notice: 'Successfully updated access code.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @access_code = @student.access_codes.find(params[:id])
    @access_code.audit_comment = "Removed Access Code For #{@access_code.for}"
    @access_code.destroy

    respond_to do |format|
      format.html { redirect_to student_access_codes_path(@student), notice: 'Successfully destroyed access code.' }
      format.js
    end
  end

  private

  def load_student
    @student = Student.find(params[:student_id])
  end

  def access_code_params
    params.require(:access_code).permit(:for, :code, :expires_at)
  end
end
