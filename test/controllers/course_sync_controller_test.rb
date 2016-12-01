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
    assert_redirected_to my_student_portal_path

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


  should "figure out if courses were added for student and/or removed and send email" do
    new_course_code = "2016_AP_NEW_W_1111__6_C_EN_A"
    existing_course_code = "2016_AP_EXST_W_9999__6_C_EN_A"

    ActionMailer::Base.deliveries = []

    course = create(:course, code: existing_course_code)
    sc = create(:student_course, course: course, student: @student)

    assert_equal 1, @student.courses.size, "SHould have one course already"


    @request.env[@course_listing_header]  = new_course_code

    post :sync

    added = assigns(:courses_added)
    removed = assigns(:courses_removed)


    assert_equal 1, @student.courses.size, "Should be one"

    assert_equal 1, added.size, "Added one"
    assert_equal 1, removed.size, "Removed one"

    assert_equal existing_course_code, removed.first
    assert_equal new_course_code, added.first

    assert !ActionMailer::Base.deliveries.empty?, "Should send an email"

  end

  should "notify the coordinator and assistant that courses were added or removed: PRIVATE METHOD TEST" do
    courses_added = ["COMP_1010"]
    courses_removed = ["MATH_2000", "HIST_1010"]

    ActionMailer::Base.deliveries = []

    student = create(:student)

    controller = CourseSyncController.new
    controller.send(:notify_coordinator, student, courses_added, courses_removed)

    assert !ActionMailer::Base.deliveries.empty?

    mail = ActionMailer::Base.deliveries.first
    assert_equal mail.to, [student.details.transcription_coordinator.email, student.details.transcription_assistant.email]
    assert_equal mail.subject, "Course List Updated: #{student.name}"



  end




end
