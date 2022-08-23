# frozen_string_literal: true

class CoursesController < AuthenticatedController
  authorize_resource

  before_action :load_term

  def index
    @courses = @term.courses
    redirect_to @term
  end

  def show
    redirect_to @term
  end

  def add_item
    course = Course.find(params[:id])
    item = Item.find(params[:item_id])

    course.add_item(item)
    redirect_to item_path(item), notice: 'Added this item to the course'
  end

  def assign_to_item
    @item = Item.find(params[:item_id])
    course_ids = params[:course_ids]

    course_ids.split(',').each do |id|
      course = Course.find(id)
      course.add_item(@item)
    end

    @courses_grouped = @item.courses.group_by { |c| { name: c.term.name, id: c.term.id } }

    respond_to do |format|
      format.html { redirect_to item_path(@item), notice: 'Assigned this courses to this item' }
      format.js
    end
  end

  def remove_item
    course = Course.find(params[:id])
    @item = Item.find(params[:item_id])

    course.remove_item(@item)
    @courses_grouped = @item.courses.group_by { |c| { name: c.term.name, id: c.term.id } }

    respond_to do |format|
      format.html { redirect_to item_path(@item), alert: 'Removed item from course' }
      format.js
    end
  end

  def new
    @course = @term.courses.build
  end

  def create
    @course = @term.courses.build(course_params)
    if @course.save
      redirect_to @term, notice: 'Successfully created course.'
    else
      render action: 'new'
    end
  end

  def edit
    @course = @term.courses.find(params[:id])
  end

  def update
    @course = @term.courses.find(params[:id])
    if @course.update(course_params)
      redirect_to @term, notice: 'Successfully updated course.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @course = @term.courses.find(params[:id])
    @course.destroy
    redirect_to @term, notice: 'Successfully destroyed course.'
  end

  private

  def load_term
    @term = Term.find(params[:term_id])
  end

  def course_params
    params.require(:course).permit(:title, :code)
  end
end
