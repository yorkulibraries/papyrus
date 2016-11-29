class CourseSyncController < ApplicationController
  before_filter :authorize_controller

  def sync
    @student = current_user

    course_list = request.headers[PapyrusSettings.course_listing_header]

    # if  course list  is nil or empty, remove all student course associations
    # Then redirect to student view
    course_code_parser = Papyrus::YorkuCourseCodeParser.new

    list = course_code_parser.unique_codes_only(course_list, PapyrusSettings.course_listing_separator)


    if list.size == 0
      @student.courses.delete_all
    else
      @student.courses.delete_all

      list.each do |code|


        course = Course.find_by_code(code)



        if course == nil

          # check if term exists, if not, create it
          term_details = course_code_parser.term_details(code)
          term = Term.where(start_date: term_details[:start_date], end_date: term_details[:end_date]).first
          if term == nil
            term = Term.new(name: term_details[:name], start_date: term_details[:start_date], end_date: term_details[:end_date])
            term.save
          end

          # create course
          course = Course.new(code: code, title: course_code_parser.short_code(code), term: term)
          course.save

        end


        sc = StudentCourse.new(student: @student, course: course)
        result = sc.save(validate: false)

      end
    end

    flash[:notice] = "Courses synced"
    redirect_to my_student_portal_path
  end

  private
  def authorize_controller
     authorize! :show, :student
  end

end
