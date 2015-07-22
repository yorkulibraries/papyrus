class SharedAccessCodesController < ApplicationController
  authorize_resource  User

  def index
    @access_codes = AccessCode.active.shared
    @expired_access_codes = AccessCode.expired.shared.limit(20)
  end

  def new
    @access_code = AccessCode.new
  end

  def create
    @access_code =  AccessCode.new(access_code_params)
    @access_code.shared = true
    @access_code.created_by = current_user
    @access_code.audit_comment = "Adding a new Shared Access Code"

    if @access_code.save
      respond_to do |format|
        format.html { redirect_to shared_access_codes_path, notice: "Successfully created shared access code." }
        format.js
      end
    else
      respond_to do |format|
        format.html { render action: 'new' }
        format.js
      end
    end

  end

  def destroy
    @access_code =  AccessCode.shared.find(params[:id])
    @access_code.audit_comment = "Removed Shared Access Code For #{@access_code.for}"
    @access_code.destroy


    respond_to do |format|
      format.html { redirect_to shared_access_codes_path, notice: "Successfully removed shared access code." }
      format.js
    end
  end

  def access_code_params
    params.require(:access_code).permit(:for, :code, :expires_at)
  end

end
