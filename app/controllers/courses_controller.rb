class CoursesController < ApplicationController
  authorize_resource

  before_filter :load_term

  def index
    redirect_to @term
  end

  def show
    redirect_to @term
  end

  def add_item
    course = Course.find(params[:id])
    item = Item.find(params[:item_id])

    course.add_item(item)
    redirect_to courses_item_path(item), notice:  "Added this item to the course"
  end

  def assign_to_item
    item = Item.find(params[:item_id])
    course_ids = params[:course_ids]


    course_ids.split(",").each do |id|
      course = Course.find(id)
      course.add_item(item)
    end

    redirect_to courses_item_path(item), notice:  "Assigned this courses to this item"
  end

  def remove_item
    course = Course.find(params[:id])
    item = Item.find(params[:item_id])

    course.remove_item(item)

    redirect_to courses_item_path(item), alert: "Removed item from course"
  end

  def new

    @course = @term.courses.build
  end

  def create
    @course = @term.courses.build(course_params)
    if @course.save
      redirect_to @term, notice:  "Successfully created course."
    else
      render action: 'new'
    end
  end

  def edit
    @course = @term.courses.find(params[:id])

  end

  def update
    @course = @term.courses.find(params[:id])
    if @course.update_attributes(course_params)
      redirect_to  @term, notice: "Successfully updated course."
    else
      render action: 'edit'
    end
  end

  def destroy
    @course = @term.courses.find(params[:id])
    @course.destroy
    redirect_to @term, notice:  "Successfully destroyed course."
  end

  private
  def load_term
    @term = Term.find(params[:term_id])
  end

  def course_params
    params.require(:course).permit( :title, :code)
  end

end
