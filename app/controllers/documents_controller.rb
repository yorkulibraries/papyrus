class DocumentsController < AuthenticatedController
  authorize_resource
  before_action :load_attachable, except: :download

  def download
    @document = Document.find(params[:id])
    file = "#{@document.attachment.path}"
    ext = @document.attachment.file.extension

    begin
      mime_type = MIME::Types.type_for(file).first.content_type
    rescue
      mime_type = "unknown"
    end

    if ["pdf", "jpg", "png", "gif", "jpeg"].include?(ext.downcase)
      disposition = "inline"
    else
      disposition = "attachment"
    end

    send_data File.read(file), type: mime_type, disposition: disposition, filename: "#{File.basename(@document.attachment_url)}"
  end

  def new
    @document = @attachable.documents.new
    @document.name = params[:name] if params[:name]
  end

  def create
    @document = @attachable.documents.build(document_params)
    @document.user = @current_user
    @document.audit_comment = "Uploaded a new document"

    respond_to do |format|
      if @document.save
        format.js
      else
        format.js
      end
    end
  end

  def edit
    @document = @attachable.documents.find(params[:id])
  end

  def update
    @document = @attachable.documents.find(params[:id])
    @document.user = @current_user
    @document.audit_comment = "Updated an existing document"

    respond_to do |format|
      if @document.update(document_params)
        format.js
      else
        format.js
      end
    end
  end

  def destroy
    @document = @attachable.documents.find(params[:id])
    @document.user = @current_user
    @document.audit_comment = "Deleted a document"

    @document.deleted = true
    @document.save(validate: false)

  end

  private
  def load_attachable
    klass = [Student, Course].detect{|c| params["#{c.name.underscore}_id"]}
    @attachable= klass.find(params["#{klass.name.underscore}_id"])
  end

  def document_params
    params.require(:document).permit(:name, :attachment, :attachment_cache)
  end
end
