class AcquisitionRequestsController < AuthenticatedController
  before_action :set_request, only: [:show, :edit, :update, :destroy, :change_status_form, :change_status, :send_to_acquisitions]
  authorize_resource

  def index
    @acquisition_requests = AcquisitionRequest.open.order("created_at desc")
    @acquisition_requests_grouped = @acquisition_requests.group_by { |r|  { name: r.requested_by.name, id: r.requested_by.id } }

    @recently_acquired = AcquisitionRequest.acquired.limit(40).order("acquired_at desc")
    @recently_cancelled = AcquisitionRequest.cancelled.limit(10).order("cancelled_at desc")
    @back_ordered = AcquisitionRequest.back_ordered.order("back_ordered_until desc")
  end

  def status
    if params[:status]
      @acquisition_requests = AcquisitionRequest.where(status: params[:status]).order("acquired_at desc").page(params[:page]).per(100)
    else
      redirect_to acquisition_requests_path
    end
  end

  def show
    @item = @acquisition_request.item

    @audits = @acquisition_request.audits
    @audits_grouped = @audits.reverse.group_by { |a| a.created_at.at_beginning_of_day }

    @users = User.all
  end

  def new
    @acquisition_request = AcquisitionRequest.new
    @item = Item.find(params[:item_id])
  end


  def edit
  end

  def create
    @acquisition_request = AcquisitionRequest.new(acquisition_request_params)
    @acquisition_request.audit_comment = "Created an acquisition item for Item #: #{@acquisition_request.item.id}"
    @acquisition_request.item = Item.find(acquisition_request_params[:item_id])
    @acquisition_request.requested_by = current_user

    respond_to do |format|
      if @acquisition_request.save
        format.html { redirect_to acquisition_request_path(@acquisition_request), notice: 'Acquisition Request was successfully created.' }
        format.js
      else
        format.html { render action: 'new' }
        format.js
      end
    end
  end

  def update
    @acquisition_request.audit_comment = "Updated an acquisition request for Item #: #{@acquisition_request.item.id}"
    respond_to do |format|
      if @acquisition_request.update(acquisition_request_params)
        format.html { redirect_to acquisition_request_path(@acquisition_request), notice: 'Acquisition Request was successfully updated.' }
        format.js
      else
        format.html { render action: 'edit' }
        format.js
      end
    end
  end

  def destroy
    @acquisition_request.audit_comment = "Removed acquisition_request for Item #: #{@acquisition_request.item.id}"
    @acquisition_request.destroy
    respond_to do |format|
      format.html { redirect_to acquisition_requests_url }
      format.js
    end
  end

  ### CHANGE STATUS ###
  def change_status_form
    @status = params[:status]
    respond_to do |format|
      format.html { redirect_to a  @acquisition_request }
      format.js
    end
  end

  def change_status
    if params[:status] == AcquisitionRequest::STATUS_ACQUIRED
      @acquisition_request.status = AcquisitionRequest::STATUS_ACQUIRED
      @acquisition_request.acquired_at = Time.now
      @acquisition_request.acquired_by = current_user
      @acquisition_request.audit_comment = "Changed status to #{AcquisitionRequest::STATUS_ACQUIRED}"

      result = @acquisition_request.update(acquisition_request_params)

    elsif params[:status] == AcquisitionRequest::STATUS_CANCELLED
      @acquisition_request.status = AcquisitionRequest::STATUS_CANCELLED
      @acquisition_request.cancelled_at = Time.now
      @acquisition_request.cancelled_by = current_user
      @acquisition_request.audit_comment = "Changed status to #{AcquisitionRequest::STATUS_CANCELLED}"
      @acquisition_request.cancellation_reason = acquisition_request_params[:cancellation_reason]

      result = @acquisition_request.save(validate: false)
    elsif params[:status] == AcquisitionRequest::STATUS_BACK_ORDERED
      @acquisition_request.back_ordered_by = current_user
      @acquisition_request.status = AcquisitionRequest::STATUS_BACK_ORDERED
      @acquisition_request.audit_comment = "Changed status to #{AcquisitionRequest::STATUS_BACK_ORDERED}"

      result = @acquisition_request.update(acquisition_request_params)
    end

    redirect_to acquisition_request_path(@acquisition_request)

  end

  def send_to_acquisitions
    where = params[:bookstore] ? "bookstore" : "acquisitions"

    AcquisitionsMailer.send_acquisition_request(@acquisition_request, current_user, params[:bookstore]).deliver_now
    #AcquisitionsMailer.test.deliver_later
    @acquisition_request.audit_comment = "Sent email to #{where}. CC: #{current_user.email}"
    @acquisition_request.save(validate: false)

    redirect_to acquisition_request_path(@acquisition_request), notice: "Sent request to #{where}"
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_request
    @acquisition_request = AcquisitionRequest.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def acquisition_request_params

    params.require(:acquisition_request).permit(:item_id, :acquisition_reason, :back_ordered_reason, :back_ordered_until, :note,
          :cancellation_reason, :acquisition_notes, :acquisition_source_type, :acquisition_source_name)

  end
end
