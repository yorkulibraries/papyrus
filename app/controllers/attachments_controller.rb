class AttachmentsController < ApplicationController
  authorize_resource
  before_filter :load_item
  
  def new
    @attachment = @item.attachments.build
  end

  def create
    @attachment = @item.attachments.build(params[:attachment])
    @attachment.user = @current_user
    
    logger.debug @attachment.user.inspect
    
    begin
      @attachment.name = File.basename(@attachment.file_url, ".*") if (params[:multi])
    rescue
      @attachment.name = @attachment.file_url
    end
    
    @attachment.audit_comment = "Uploaded a new file"
     
    if @attachment.save
      
      respond_to do |format|
            format.html { redirect_to @item, notice: "Successfully created attachment." }
            format.js do
               render :text => render_to_string(partial: @attachment)
            end
        end      
    else
      respond_to do |format|
        format.html { render action: 'new' }
        format.js do 
            render text: "There was a problem uploading this file. If the problem persists, try uploading it using a signle file uploader."
        end
      end
    end
  end

  def edit
    @attachment = @item.attachments.find(params[:id])
  end

  def update
    @attachment = @item.attachments.find(params[:id])
    @attachment.user = @current_user
    @attachment.audit_comment = "Updated an existing file"
    if @attachment.update_attributes(params[:attachment])
      redirect_to @item, notice: "Successfully updated attachment."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @attachment = @item.attachments.find(params[:id]) 
    @attachment.deleted = true
    @attachment.save(validate: false)
      
    # do not remove the attachment for now   
    #@attachment.destroy
    
    redirect_to @item, notice: "Successfully removed attachment."
  end
  
  
  def get_file
    @attachment = @item.attachments.find(params[:id])    
    file = "#{@attachment.file.path}"    
    mime_type = File.mime_type?(file)
    
    send_data File.read(file), type: mime_type, disposition: 'attachment', filename: "#{File.basename(@attachment.file_url)}"
  end
  
  
  private 
  def load_item
    @item = Item.find(params[:item_id])
  end
end
