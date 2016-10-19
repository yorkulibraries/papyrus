require 'test_helper'

class CourseSyncControllerTest < ActionController::TestCase

  setup do
    @student = create(:student)
    log_user_in(@student)

    @course_listing_header = PapyrusSettings.course_listing_header
    @course_listing_separator = PapyrusSettings.course_listing_separator
  end

  should "remove all course student links if the course listing header is empty" do
    create_list(:student_course, 2, student: @student)
    @request.env[@course_listing_header] = nil

    assert_equal 2, @student.courses.size, "Should be two courses"

    post :sync
    #assert_redirected_to student_view_path

    assert_equal 0, @student.courses.size, "There should be no courses"

  end



end
