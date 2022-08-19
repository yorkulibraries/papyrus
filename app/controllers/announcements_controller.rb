class AnnouncementsController < AuthenticatedController
  authorize_resource

  def index
    @announcements = Announcement.non_expired
    @expired_announcements = Announcement.expired.limit(20)
  end

  def new
    @announcement = Announcement.new
  end

  def edit
    @announcement = Announcement.find(params[:id])
  end

  def create
    @announcement = Announcement.new(announcement_params)
    @announcement.user = current_user
    @announcement.audit_comment = "Adding a new Annoucement message for #{@announcement.audience}"

    if @announcement.save
      respond_to do |format|
        format.html { redirect_to announcements_path, notice: 'Successfully created announcement' }
        format.js
      end
    else
      respond_to do |format|
        format.html { render action: 'new' }
        format.js
      end
    end
  end

  def update
    @announcement = Announcement.find(params[:id])
    @announcement.audit_comment = 'Updating announcement'
    if @announcement.update(announcement_params)
      pp @annoucement
      respond_to do |format|
        format.html { redirect_to announcements_path, notice: 'Successfully updated announcement.' }
        format.js { render nothing: true }
      end
    else
      respond_to do |format|
        format.html { render action: 'edit' }
        format.js
      end
    end
  end

  def destroy
    @announcement = Announcement.find(params[:id])
    @announcement.audit_comment = "Removed Announcement message for #{@announcement.audience}"
    @announcement.destroy

    respond_to do |format|
      format.html do
        redirect_to announcements_path,
                    notice: "Successfully removed Announcement message for #{@announcement.audience}"
      end
      format.js
    end
  end

  def hide
    # ids = [params[:id], *cookies.signed[:hidden_announcement_ids]]
    # cookies.permanent.signed[:hidden_announcement_ids] = ids

    ids = if !session[:hidden_announcement_ids].nil?
            session[:hidden_announcement_ids].push params[:id]
          else
            [params[:id]]
          end

    session[:hidden_announcement_ids] = ids

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  private

  def announcement_params
    params.require(:announcement).permit(:ends_at, :message, :starts_at, :audience, :active)
  end
end
