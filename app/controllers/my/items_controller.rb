class My::ItemsController < ApplicationController

  before_filter :authorize_controller, :load_student, :check_terms_acceptance

  def show
    @items = @student.current_items
    @courses = @items.map {|i| i.courses }.flatten.map{ |c| short_name(c.code)}.uniq

    @courses_grouped = @courses.group_by { |c| c.split(" ").first }

    if params[:course].present?
      course_chuncks = params[:course].split("_")
      i = @items.joins(:courses).group('items.id').where("courses.code LIKE '%_#{course_chuncks[0]}_%_%#{course_chuncks[1]}_%'")
      @items_grouped = i.group_by { |i| i.item_type }
    else
      @items_grouped = @items.group_by { |i| i.item_type }
    end
  end

  private
  def authorize_controller
     authorize! :show, :student
  end

  def load_student
    @student = Student.find(current_user.id)
  end

  def check_terms_acceptance
    redirect_to my_terms_path unless session[:terms_accepted]
  end

end
