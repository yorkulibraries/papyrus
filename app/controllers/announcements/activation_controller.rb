# frozen_string_literal: true

class Announcements::ActivationController < AuthenticatedController
  before_action :load_announcement
  authorize_resource Announcement

  def update
    @announcement.update active: true
    redirect_to announcements_url
  end

  def destroy
    @announcement.update active: false
    redirect_to announcements_url
  end

  private

  def load_announcement
    @announcement = Announcement.find(params[:announcement_id])
  end
end
