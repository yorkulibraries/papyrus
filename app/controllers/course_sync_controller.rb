class CourseSyncController < ApplicationController
  before_filter :authorize_controller

  def sync
    @student = current_user

    course_list = request.headers[PapyrusSettings.course_listing_header]

    # if  course list  is nil or empty, remove all student course associations
    # Then redirect to student view
    course_code_parser = Papyrus::YorkuCourseCodeParser.new

    list = course_code_parser.unique_codes_only(course_list, PapyrusSettings.couse_listing_separator)

    if list.size == 0
      @student.courses.delete_all
    else
      @student.course.delete_all

      list.each do |code|
        ## find if course exists
        ## if doesn't, figure out if term exists, if not create it
        ## create course
        ## assign course to student
      end
    end


    redirect_to student_view_path
  end

  private
  def authorize_controller
     authorize! :show, :student
  end

end
