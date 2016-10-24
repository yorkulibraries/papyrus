require 'test_helper'

class CourseSyncControllerTest < ActionController::TestCase

  setup do
    @student = create(:student)
    log_user_in(@student)

    @course_listing_header = PapyrusSettings.course_listing_header
    PapyrusSettings.course_listing_separator = ","
  end

  should "remove all course student links if the course listing header is empty" do
    create_list(:student_course, 2, student: @student)
    @request.env[@course_listing_header] = nil

    assert_equal 2, @student.courses.size, "Should be two courses"

    post :sync
    #assert_redirected_to student_view_path

    assert_equal 0, @student.courses.size, "There should be no courses"

  end

  should "Remove existing courses assigned to student and reattach new ones" do
    create_list(:student_course, 3, student: @student)
    course = create(:course, code: "2016_AP_POLS_Y_1000__6_C_EN_A")

    sc = create(:student_course, student: @student, course: course)

    assert_equal 4, @student.courses.size, "Should be 4"

    @request.env[@course_listing_header]  = "#{course.code}"

    post :sync

    assert_equal 1, @student.courses.size, "Should be one now"

  end


  should "remove existing courses and create new courses and terms" do
    assert_equal 0, @student.courses.size, "Should be 0"

    @request.env[@course_listing_header]  = "2016_AP_MATH_W_9000__6_C_EN_A,2016_AP_ECON_FW_2000__6_C_EN_A,2016_AP_HIST_S_1000__6_C_EN_A"


    assert_difference "Course.count", 3 do
      assert_difference "Term.count", 3 do
        post :sync
      end
    end

    assert_equal 3, @student.courses.count, "Should be three now"

  end

  should "Not create a new term but create new course" do
    term_details =  Papyrus::YorkuCourseCodeParser.new.term_details("2016_AP_MATH_W_9000__6_C_EN_A")
    term = Term.new(name: term_details[:name], start_date: term_details[:start_date], end_date: term_details[:end_date])
    term.save
    @request.env[@course_listing_header]  = "2016_AP_MATH_W_9000__6_C_EN_A"

    assert_difference "Course.count", 1 do
      assert_no_difference "Term.count" do
        post :sync
      end
    end

    assert_equal 1, @student.courses.count, "Should be one now"

  end




end
