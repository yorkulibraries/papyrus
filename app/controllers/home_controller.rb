class HomeController < ApplicationController
  before_filter :authorize_controller

  def index
    @students = Student.active.assigned_to(current_user.id).order("student_details.created_at asc") #.limit(20)
    @current_items_counts = Student.item_counts(@students.collect { |s| s.id }, "current")

    @recently_worked_with_items = Item.recently_worked_with(current_user.id).limit(10)
  end

  def active_sessions
    @sessions = session.to_hash
    render text: @sessions.inspect
  end

  private
  def authorize_controller
      authorize! :show, :dashboard
   end
end
