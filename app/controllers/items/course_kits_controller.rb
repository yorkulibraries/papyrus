class Items::CourseKitsController < AuthenticatedController
  authorize_resource Item

  def new
    @item = Item.new
    @course_kit_form = Item::CourseKitForm.new
  end

  def create
    @course_kit_form = Item::CourseKitForm.new code_params

    @item = Item.new item_params
    @item.item_type = Item::COURSE_KIT
    @item.user = @current_user
    @item.audit_comment = 'Creating a new course kit.'
    @item.course_code = @course_kit_form.code

    if @item.title.blank?
      c = @course_kit_form
      @item.title = "Course Kit For #{c.year} / #{c.subject}_#{c.course_id}.#{c.credits} #{c.section}"
    end

    if @course_kit_form.valid? && @item.save

      if params[:create_acquisition_request] == 'yes'
        @acquisition_request = AcquisitionRequest.new
        @acquisition_request.requested_by = @current_user
        @acquisition_request.acquisition_reason = params[:item][:acquisition_request][:acquisition_reason]
        @acquisition_request.note = params[:item][:acquisition_request][:note]
        @acquisition_request.item = @item
        @acquisition_request.audit_comment = "Created an acquisition request for #{@item.title}"
        @acquisition_request.save(validate: false)
      end

      redirect_to item_path(@item)
    else
      render :new
    end
  end

  def edit
    @item = Item.find params[:id]
    @course_kit_form = Item::CourseKitForm.new
    @course_kit_form.code = @item.course_code
  end

  def update
    @course_kit_form = Item::CourseKitForm.new code_params

    @item = Item.find params[:id]
    @item.audit_comment = 'Updating Course Kit Details'
    @item.course_code = @course_kit_form.code

    if params[:item][:title].blank?
      c = @course_kit_form
      params[:item][:title] = "Course Kit For #{c.year} / #{c.subject}_#{c.course_id}.#{c.credits} #{c.section}"
    end

    if @course_kit_form.valid? && @item.update(item_params)
      redirect_to @item
    else
      render :edit
    end
  end

  private

  def code_params
    params.require(:code).permit(:year, :faculty, :subject, :term, :credits, :section, :course_id)
  end

  def item_params
    params.require(:item).permit(:title, :unique_id, :callnumber, :author, :isbn, :publisher, :published_date,
                                 :language_note, :edition, :physical_description, :source, :source_note, acquisition_request: %i[acquisition_reason note])
  end
end
