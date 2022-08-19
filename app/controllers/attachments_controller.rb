class AttachmentsController < AuthenticatedController
  authorize_resource
  before_action :load_item

  def new
    @attachment = @item.attachments.build
    render 'new_url' if params[:url]
  end

  def create
    @attachment = @item.attachments.build(attachment_params)
    @attachment.user = @current_user

    if @attachment.url.blank?

      @attachment.name = File.basename(@attachment.file_url, '.*')
      @attachment.is_url = false

      @attachment.audit_comment = 'Uploaded a new file'
    else

      @attachment.is_url = true
      @attachment.audit_comment = 'Adding a new URL'
    end

    if @attachment.save
      respond_to do |format|
        format.html { redirect_to item_path(@item), notice: 'Successfully uploaded a file' }
        format.js
      end
    else
      respond_to do |format|
        format.html { render action: 'new' }
        format.js
      end
    end
  end

  def old_create
    @attachment = @item.attachments.build(attachment_params)
    @attachment.user = @current_user

    logger.debug @attachment.user.inspect

    ## URL LINK OR FILE UPLOAD

    if @attachment.url.blank?

      begin
        @attachment.name = File.basename(@attachment.file_url, '.*') if params[:multi]
      rescue StandardError
        @attachment.name = @attachment.file_url
      end

      @attachment.audit_comment = 'Uploaded a new file'
    else

      @attachment.is_url = true
      @attachment.audit_comment = 'Adding a new URL'
    end

    if @attachment.save

      respond_to do |format|
        if params[:uploadify]
          format.html { render text: render_to_string(partial: @attachment, layout: false) }
        else
          format.html { redirect_to @item, notice: 'Successfully created a file.' }
        end

        format.js do
          render text: render_to_string(partial: @attachment, layout: false)
        end
      end
    else
      respond_to do |format|
        format.html { render action: 'new' }
        format.js do
          render text: 'There was a problem uploading this file. If the problem persists, try uploading it using a signle file uploader.'
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
    @attachment.audit_comment = 'Updated an existing file'
    if @attachment.update(attachment_params)
      redirect_to @item, notice: 'Successfully updated a file.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @attachment = @item.attachments.find(params[:id])
    @attachment.deleted = true
    @attachment.audit_comment = 'Removing an existing file'
    @attachment.save(validate: false)

    unless @attachment.is_url?
      # rename file and move it deleted directory
      new_filepath = "#{File.dirname(@attachment.file.file.path)}/deleted/#{@attachment.id}-#{@attachment.file.file.filename}"
      @attachment.file.file.move_to(new_filepath)
    end

    # do not remove the attachment for now
    # @attachment.destroy

    respond_to do |format|
      format.html { redirect_to @item, notice: 'Successfully removed a file.' }
      format.js
    end
  end

  def delete_multiple
    ids = params[:ids]
    ids.each do |id|
      a = @item.attachments.find(id)
      a.deleted = true
      a.audit_comment = 'Removing existing file'
      a.save(validate: false)

      next if a.is_url?

      # rename file and move it deleted directory
      new_filepath = "#{File.dirname(a.file.file.path)}/deleted/#{a.id}-#{a.file.file.filename}"
      a.file.file.move_to(new_filepath)
    end

    redirect_to @item, notice: 'Successfully deleted multiple files'
  end

  def get_file
    @attachment = @item.attachments.find(params[:id])
    file = "#{@attachment.file.path}"

    begin
      mime_type = MIME::Types.type_for(file).first.content_type
    rescue StandardError
      mime_type = 'unknown'
    end

    send_data File.read(file), type: mime_type, disposition: 'attachment',
                               filename: "#{File.basename(@attachment.file_url)}"
  end

  private

  def load_item
    @item = Item.find(params[:item_id])
  end

  def attachment_params
    params.require(:attachment).permit(:name, :item_id, :file, :file_cache, :full_text, :url, :access_code_required,
                                       :is_url)
  end
end
