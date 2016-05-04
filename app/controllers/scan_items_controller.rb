class ScanItemsController < ApplicationController
  authorize_resource
  before_filter :load_scan_list
  protect_from_forgery except: [:new, :edit]

  def new
    @scan_item = @scan_list.scan_items.new
    @scan_item.item_id = params[:item_id]  if params[:item_id]
  end
  

  def create
    @scan_item =  @scan_list.scan_items.new(scan_item_params)
    @scan_item.created_by = current_user
    @scan_item.audit_comment = "Adding a new Scan Item"
    @scan_item.status = ScanItem::STATUS_NEW

    if @scan_item.save
      respond_to do |format|
        format.html { redirect_to [@scan_list, @scan_item], notice: "Successfully created Scan Item" }
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
    @scan_item = @scan_list.scan_items.find(params[:id])
  end

  def update
    @scan_item = @scan_list.scan_items.find(params[:id])
    @scan_item.audit_comment = "Updating Scan Item"
    if @scan_item.update_attributes(scan_item_params)
      respond_to do |format|
        format.html { redirect_to  [@scan_list, @scan_item], notice: "Successfully updated scan item." }
        format.js
      end
    else
      respond_to do |format|
        format.html { render action: 'edit' }
        format.js
      end
    end
  end

  def destroy
    @scan_item = @scan_list.scan_items.find(params[:id])
    @scan_item.audit_comment = "Removed Scan List"
    @scan_item.destroy


    respond_to do |format|
      format.html { redirect_to [@scan_list, @scan_item], notice: "Successfully removed Scan Item" }
      format.js
    end
  end

  private
  def load_scan_list
    @scan_list = ScanList.find(params[:scan_list_id])
  end

  def scan_item_params
    params.require(:scan_item).permit(:summary, :status, :assigned_to_id, :item_id, :due_date)
  end
end
