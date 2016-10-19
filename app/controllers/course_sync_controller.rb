class CourseSyncController < ApplicationController
  before_filter :authorize_controller

  def sync
    @student = current_user

    course_list = request.headers[PapyrusSettings.course_listing_header]

    # if  course list  is nil or empty, remove all student course associations
    # Then redirect to student view

    if course_list == nil || course_list.size == 0
      @student.courses.delete_all

    else

    end

    ## COURSE SAMPLE 
    # if course list has items
    # 1) Strip out TUT and LECT endings and see if courses already exist, if not create them
    # 2) remove existing student course associations
    # 3) Add new onese
    # 4) Redirect to student view

    redirect_to student_view_path
  end

  private
  def authorize_controller
     authorize! :show, :student
  end

end
