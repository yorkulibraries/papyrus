class ItemsController < ApplicationController
  authorize_resource
  
  def index        
    page_number = params[:page] ||= 1
    
    if params[:order] && params[:order] == "alpha"     
      @items = Item.alphabetical.page(page_number)
    else
      @items = Item.by_date.page(page_number)
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
  
  def assign_to_students
    item = Item.find(params[:id])
    student_ids = params[:student_ids]
    date = params[:expires_on][:date] if params[:expires_on]
    
    student_ids.split(",").each do |id|  
      student = Student.new
      student.id = id      
      item.assign_to_student(student, date)
    end 
    
    redirect_to item, :notice => "Assigned this item to students"   
  end
  
  def assign_many_to_student
    student = Student.find(params[:student_id])
    item_ids = params[:item_ids]
    date = params[:expires_on][:date] if params[:expires_on]
    
    item_ids.split(",").each do |id|
      item = Item.find(id)
      item.assign_to_student(student, date)
    end
    
    redirect_to student, :notice => "Assigned items to this student"
  end  
  
  def withhold_from_student
    item = Item.find(params[:id])
    student = Student.find(params[:student_id])
    
    item.withhold_from_student(student)
    
    redirect_to item, :notice => "Removed student access" unless params[:return_to_student]
    redirect_to student, :notice =>"Removed item access" if params[:return_to_student]
  end
  
  
  def show
    @item = Item.find(params[:id])
  end

  def new    
    
    @item = Item.new
    if params[:bib_record_id]
     bib_record = BibRecord.new(APP_CONFIG[:bib_search])
     bib_item = bib_record.find_item(params[:bib_record_id])
     @item = bib_record.build_item_from_search_result(bib_item, Item::BOOK)
    end
         
  end

  def create
    @item = Item.new(params[:item])
    @item.user = @current_user
    @item.audit_comment = "Creating a new item."
    if @item.save
      if params[:create_acquisition_request] == "yes"
        @acquisition_request = AcquisitionRequest.new 
        @acquisition_request.requested_by = @current_user
        @acquisition_request.requested_by_date = Date.today
        @acquisition_request.fulfilled = false
        @acquisition_request.cancelled = false
        @acquisition_request.item = @item
        @acquisition_request.save(:validate => false)        
      end
      redirect_to @item, :notice => "Successfully created item."
    else
      render :action => 'new'
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    @item.audit_comment = "Updated an existing item."
    if @item.update_attributes(params[:item])
      redirect_to @item, :notice  => "Successfully updated item."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.audit_comment = "Removed the item."
    @item.destroy
    redirect_to items_path, :notice => "Successfully destroyed item."
  end
  
  
  def zipped_files
      require 'zip/zip'
      @item = Item.find(params[:id])
      file_name = "#{@item.unique_id}.zip"
      show_file_name = "#{@item.title.parameterize}.zip"
      
      if file_name.length > 150
       file_name = file_name[0..150]
      end
      
      zipfile_name = "/tmp/papyrus-#{file_name}"
      
      File.delete(zipfile_name) if File.exists?(zipfile_name)
      counter = 0
      Zip::ZipFile.open(zipfile_name, Zip::ZipFile::CREATE) do |zipfile|
        @item.attachments.available.each do |filename|
          # Two arguments:
          # - The name of the file as it will appear in the archive
          # - The original file, including the path to find it
          zipfile.add("#{counter}-" + File.basename(filename.file_url), "#{filename.file.path}")
          counter += 1
        end
      end
      
      send_data File.read(zipfile_name), :type => 'application/zip', :disposition => 'attachment', :filename => show_file_name
      
  end
  
end
