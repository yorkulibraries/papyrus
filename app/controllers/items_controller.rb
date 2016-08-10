class ItemsController < ApplicationController
  authorize_resource

  def index
    page_number = params[:page] ||= 1
    @search_results = "local"

    if params[:order] && params[:order] == "alpha"
      @items = Item.alphabetical.page(page_number)
    else
      @items = Item.by_date.page(page_number)
    end

  end

  def audit_trail
    @item = Item.find(params[:id])
    @audits = @item.audits | @item.associated_audits
    @audits.sort! { |a, b| a.created_at <=> b.created_at }


    @audits_grouped = @audits.reverse.group_by { |a| a.created_at.at_beginning_of_day }

    respond_to do |format|
      format.html
      format.xlsx {
        response.headers['Content-Disposition'] = "attachment; filename=\"#{@item.id}_audit_trail.xlsx\""
      }

    end
  end

  def courses
    @item = Item.find(params[:id])
    @course_grouped = @item.courses.group_by { |c| c.term.name }
  end

  def acquisition_requests
    @item = Item.find(params[:id])
    @pending_acquisition_requests = @item.acquisition_requests.pending
    @cancelled_acquisition_requests = @item.acquisition_requests.cancelled.limit(5)
    @fulfilled_acquisition_requests = @item.acquisition_requests.fulfilled.limit(5)
  end

  def scan_lists
    @item = Item.find(params[:id])
    @item_scan_lists = @item.scan_lists.not_completed.group(:id)
    @scan_lists = ScanList.not_completed
  end

  def assign_to_students
    @item = Item.find(params[:id])
    student_ids = params[:student_ids]
    date = params[:expires_on][:date] if params[:expires_on]

    student_ids.split(",").each do |id|
      student = Student.new
      student.id = id
      @item.assign_to_student(student, date)
      StudentMailer.items_assigned_email(student, [@item]).deliver_later
    end

    @students = Student.where("id IN (?)", student_ids)

    respond_to do |format|
      format.html { redirect_to @item, notice:  "Assigned this item to students" }
      format.js
    end
  end

  def renew_access
    @student = params[:student_id]
    @item = Item.find(params[:id])
  end
  

  def assign_many_to_student
    @student = Student.active.find(params[:student_id])
    item_ids = params[:item_ids]
    date = params[:expires_on][:date] if params[:expires_on]

    @items = Array.new
    item_ids.split(",").each do |id|
      i = Item.find_by_id(id)
      i.assign_to_student(@student, date)
      @items << i
    end

    StudentMailer.items_assigned_email(@student, @items).deliver_later

    respond_to do |format|
      format.html { redirect_to @student, notice: "Assigned items to this student" }
      format.js
    end
  end

  def withhold_from_student
    item = Item.find(params[:id])
    student = Student.find(params[:student_id])

    item.withhold_from_student(student)

    redirect_to item, notice: "Removed student access" unless params[:return_to_student]
    redirect_to student, notice: "Removed item access" if params[:return_to_student]
  end


  def show
    @item = Item.find(params[:id])
    @courses_grouped = @item.courses.group_by { |c| { name: c.term.name, id: c.term.id } }
  end

  def new

    @item = Item.new
    if params[:bib_record_id]
     source = params[:source] || BibRecord::VUFIND

     bib_record = BibRecord.new
     bib_item = bib_record.find_item(params[:bib_record_id], source)
     @item = bib_record.build_item_from_search_result(bib_item, Item::BOOK, source)
    end

  end

  def create
    ## Check if we need to create an acquisition request, if yes make it, but don't save it yet
    if params[:create_acquisition_request] == "yes"
      @acquisition_request = AcquisitionRequest.new
      @acquisition_request.requested_by = @current_user
      @acquisition_request.acquisition_reason = params[:item][:acquisition_request][:acquisition_reason]
      @acquisition_request.note = params[:item][:acquisition_request][:note]
    end

    @item = Item.new(item_params)
    @item.user = @current_user
    @item.audit_comment = "Creating a new item."
    if @item.save
      ## Only save if the object is created
      unless @acquisition_request == nil
        @acquisition_request.item = @item
        @acquisition_request.audit_comment = "Created an acquisition request for #{@item.title}"
        @acquisition_request.save(validate: false)
      end

      redirect_to @item, notice:  "Successfully created item."
    else
      render action: 'new'
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    @item.audit_comment = "Updated an existing item."
    if @item.update_attributes(item_params)
      redirect_to @item, notice:  "Successfully updated item."
    else
      render action: 'edit'
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.audit_comment = "Removed the item."
    @item.destroy
    redirect_to items_path, notice:  "Successfully destroyed item."
  end


  def zipped_files
      require 'zip/zip'

      @item = Item.find(params[:id])
      file_name = "#{@item.unique_id}.zip"
      show_file_name = "#{@item.title.parameterize}.zip"

      if file_name.length > 150
       file_name = file_name[0..150]
      end

      # zipfile_name = "/tmp/papyrus-#{file_name}"
      # File.delete(zipfile_name) if File.exists?(zipfile_name)
      begin
        temp_file = Tempfile.new("temp-papyrus-#{file_name}")

        #Initialize the temp file as a zip file
        Zip::ZipOutputStream.open(temp_file) { |zos| }

        counter = 0
        Zip::ZipFile.open(temp_file.path, Zip::ZipFile::CREATE) do |zipfile|
          @item.attachments.files.available.each do |filename|
            # Two arguments:
            # - The name of the file as it will appear in the archive
            # - The original file, including the path to find it
            zipfile.add("#{counter}-" + File.basename(filename.file_url), "#{filename.file.path}")
            counter += 1
          end
        end

        send_data File.read(temp_file), type: 'application/zip', disposition: 'attachment', filename: show_file_name
      ensure
        temp_file.close
        temp_file.unlink
      end
  end

  private
  def item_params
    params.require(:item).permit( :title, :unique_id, :item_type, :callnumber, :author, :isbn, :publisher, :published_date,
                                  :language_note, :edition, :physical_description, :source, :source_note, acquisition_request: [:acquisition_reason, :note])
  end

end
