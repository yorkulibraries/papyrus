class AcquisitionRequestsController < ApplicationController
  authorize_resource

  def index
    if params[:which] == "fulfilled"
      @filter_title = "Fulfilled"
      @acquisition_requests = AcquisitionRequest.fulfilled
    elsif params[:which] == "cancelled"
      @filter_title = "Cancelled"
      @acquisition_requests = AcquisitionRequest.cancelled
    else
      @filter_title = "Pending"
      @acquisition_requests = AcquisitionRequest.pending
    end

  end

  def show
    @acquisition_request = AcquisitionRequest.find(params[:id])
  end

  def for_item
    if params[:item_id]
      @acquisition_request = AcquisitionRequest.new
      @acquisition_request.requested_by = @current_user
      @acquisition_request.requested_by_date = Date.today
      @acquisition_request.fulfilled = false
      @acquisition_request.cancelled = false
      @acquisition_request.item_id = params[:item_id]
      # @acquisition_request.audit_comment = "Added an acquisition report for Item ##{params[:item_id]}"
      @acquisition_request.save(:validate => false)

      redirect_to acquisition_requests_item_path(:id => params[:item_id]), :notice => "Created acquisition request for this item."
    else
      redirect_to root_path, :notice => "Item ID must be specified"
    end

  end

  def edit
    @acquisition_request = AcquisitionRequest.find(params[:id])
  end

  def update
    @acquisition_request = AcquisitionRequest.find(params[:id])


    if @acquisition_request.update_attributes(params[:acquisition_request])
      redirect_to @acquisition_request, :notice  => "Successfully updated acquisition request."
    else
      render :action => 'edit'
    end
  end

  def fulfill
    @acquisition_request = AcquisitionRequest.find(params[:id])
    if @acquisition_request
      @acquisition_request.fulfill(current_user)
    end

    redirect_to @acquisition_request
  end


  def remove_note
    @acquisition_request = AcquisitionRequest.find(params[:id])
    if @acquisition_request
      @acquisition_request.remove_note(params[:note_id])
    end

    redirect_to @acquisition_request, :notice  => "Removed the note."
  end

  def destroy
    @acquisition_request = AcquisitionRequest.find(params[:id])

    @acquisition_request.cancell(current_user)
    redirect_to acquisition_requests_url, :notice => "Successfully cancelled acquisition request."
  end
end
