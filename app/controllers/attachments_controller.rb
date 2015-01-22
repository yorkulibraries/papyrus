class AttachmentsController < ApplicationController
  authorize_resource
  before_filter :load_item

  def new
    @attachment = @item.attachments.build

    render "new_url" if params[:url]
  end

  def create
    @attachment = @item.attachments.build(params[:attachment])
    @attachment.user = @current_user

    logger.debug @attachment.user.inspect

    ## URL LINK OR FILE UPLOAD

    if @attachment.url.blank?

      begin
        @attachment.name = File.basename(@attachment.file_url, ".*") if (params[:multi])
      rescue
        @attachment.name = @attachment.file_url
      end

      @attachment.audit_comment = "Uploaded a new file"
    else

      @attachment.is_url = true
      @attachment.audit_comment = "Adding a new URL"
    end


    if @attachment.save

      respond_to do |format|
            format.html { redirect_to @item, notice: "Successfully created a file." }
            format.js do
               render text: render_to_string(partial: @attachment)
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
      redirect_to @item, notice: "Successfully updated a file."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @attachment = @item.attachments.find(params[:id])
    @attachment.deleted = true
    @attachment.audit_comment = "Removing an existing file"
    @attachment.save(validate: false)

    unless @attachment.is_url?
      # rename file and move it deleted directory
      new_filepath = "#{File.dirname(@attachment.file.file.path)}/deleted/#{@attachment.id}-#{@attachment.file.file.filename}"
      @attachment.file.file.move_to(new_filepath)
    end

    # do not remove the attachment for now
    #@attachment.destroy

    redirect_to @item, notice: "Successfully removed a file."
  end


  def delete_multiple
    ids = params[:ids]
    ids.each do |id|
      a = @item.attachments.find(id)
      a.deleted = true
      a.audit_comment = "Removing existing file"
      a.save(validate: false)

      unless a.is_url?
        # rename file and move it deleted directory
        new_filepath = "#{File.dirname(a.file.file.path)}/deleted/#{a.id}-#{a.file.file.filename}"
        a.file.file.move_to(new_filepath)
      end
    end

    redirect_to @item, notice: "Successfully deleted multiple files"
  end

  def get_file
    @attachment = @item.attachments.find(params[:id])
    file = "#{@attachment.file.path}"
    #mime_type = File.mime_type?(file)
    mime_type = MIME::Types.type_for(file).first.content_type 

    send_data File.read(file), type: mime_type, disposition: 'attachment', filename: "#{File.basename(@attachment.file_url)}"
  end


  private
  def load_item
    @item = Item.find(params[:item_id])
  end
end
