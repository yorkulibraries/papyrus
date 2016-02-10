class ScanListsController < ApplicationController
  authorize_resource
  before_filter :load_scan_list, except: [:index, :create, :new]

  def index

    @scan_lists = ScanList.all

  end

  def new
    @scan_list = ScanList.new
  end

  def edit
  end

  def create
    @scan_list =  ScanList.new(scan_list_params)
    @scan_list.created_by = current_user
    @scan_list.audit_comment = "Adding a new Scan List"
    @scan_list.status = ScanList::STATUS_NEW

    if @scan_list.save
      respond_to do |format|
        format.html { redirect_to @scan_list, notice: "Successfully created Scan List" }
        format.js
      end
    else
      respond_to do |format|
        format.html { render action: 'new' }
        format.js
      end
    end

  end

  def update

    @scan_list.audit_comment = "Updating Scan List"
    if @scan_list.update_attributes(scan_list_params)
      respond_to do |format|
        format.html { redirect_to  @scan_list, notice: "Successfully updated scan list." }
        format.js { render  nothing: true }
      end
    else
      respond_to do |format|
        format.html { render action: 'edit' }
        format.js
      end
    end
  end

  def destroy
    @scan_list.audit_comment = "Removed Scan List"
    @scan_list.destroy


    respond_to do |format|
      format.html { redirect_to scan_lists_path, notice: "Successfully removed Scan List" }
      format.js
    end
  end



  private
  def scan_list_params
    params.require(:scan_list).permit(:name, :status)
  end

  def load_scan_list
    @scan_list = ScanList.find(params[:id])
  end

end
