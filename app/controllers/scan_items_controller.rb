class ScanItemsController < ApplicationController
  authorize_resource
  before_filter :load_scan_list

  def new
    @scan_item = @scan_list.scan_items.new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def load_scan_list
    @scan_list = ScanList.find(params[:scan_list_id])
  end

  def scan_item_params
    params.require(:scan_item).permit(:summary, :status, :assigned_to_id, :item_id, :due_date)
  end
end
