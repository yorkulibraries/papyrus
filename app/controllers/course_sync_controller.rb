class CourseSyncController < ApplicationController
  before_filter :authorize_controller

  def update
    @student = current_user

    course_list = request.headers[PapyrusSettings.course_listing_header]

    # if  course list  is nil or empty, remove all student course associations
    # Then redirect to student view

    # if course list has items
    # 1) Strip out TUT and LECT endings and see if courses already exist, if not create them
    # 2) remove existing student course associations
    # 3) Add new onese
    # 4) Redirect to student view

  
  end

  private
  def authorize_controller
     authorize! :show, :student
  end

end
