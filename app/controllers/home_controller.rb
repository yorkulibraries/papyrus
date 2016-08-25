class HomeController < ApplicationController
  before_filter :authorize_controller

  def index

    @students = Student.active.assigned_to(current_user.id).order("student_details.updated_at asc").limit(20)

    @work_history = current_user.work_history

    @scan_lists = ScanList.not_completed.where(assigned_to_id: current_user.id)

    @scan_items = ScanItem.not_completed.where(assigned_to_id: current_user.id)
  end

  def active_users
    @users = User.not_students.where("last_active_at > ?", 10.minutes.ago)
    @students = Student.where("last_active_at > ?", 10.minutes.ago)
  end

  private

  def authorize_controller
      authorize! :show, :dashboard
   end
end
