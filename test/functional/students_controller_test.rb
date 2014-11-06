require 'test_helper'

class StudentsControllerTest < ActionController::TestCase

  setup do
    @user = Factory.create(:user, :role => User::ADMIN)
    log_user_in(@user)
  end

  ############# CREATE AND UPDATE TESTS ###############

  should "create a new student" do
    student_details = { student_number: '123232', preferred_phone: '11232', cds_counsellor: 'dadf', transcription_coordinator_id: @user.id,
      transcription_assistant_id: @user.id }

    assert_difference ["Student.count", "StudentDetails.count"], 1 do
      post :create, student: {name: "dude", email: "1@1.com", username: "dude", student_details_attributes: student_details}
    end

    student = assigns(:student)
    assert student, "student object should not be nil"
    assert_redirected_to student_url(student)
  end

  should "update an existing student" do
    student = create(:student, name: "old")
    details = create(:student_details, student: student, student_number: "000")

    student_details = { student_number: '111', preferred_phone: '11232', cds_counsellor: 'dadf', transcription_coordinator_id: @user.id,
        transcription_assistant_id: @user.id }
    post :update, id: student.id, student: { name: "new", student_details_attributes: student_details}

    assert_redirected_to student

    student = assigns(:student)
    assert_equal "new", student.name, "New name"
    assert_equal 111, student.student_details.student_number, "New student number"

  end

  ############ DISPLAY TESTS ################

  should "show audit trail" do
    student = create(:student)
    get :audit_trail, id: student.id

    assert assigns(:student), "Need student object"
    assert assigns(:audits), "Audits should be there"
    assert assigns(:audits_grouped), "They should be grouped"
  end

  should "show a list of active students" do
    create_list(:student, 4, inactive: false)
    create_list(:student, 5, inactive: true)

    get :index

    students = assigns(:students)
    assert_equal 4, students.size, "There should be four active students"
  end

  should "show a list of inactive students" do
    create_list(:student, 2, inactive: false)
    create_list(:student, 5, inactive: true)

    get :inactive
    students = assigns(:students)
    assert_equal 5, students.size, "There should be 5 inactive students"
  end


  should "display student details and only current items, not expired ones" do
    student = create(:student)
    create_list(:item_connection, 3, :student => student, :expires_on => Date.today - 1.year)
    create_list(:item_connection, 6, :student => student, :expires_on => Date.today + 1.year)

    get :show, :id => student.id

    assert_response :success

    student = assigns(:student)
    items = assigns(:items)
    items_grouped = assigns(:items_grouped)

    assert student
    assert items
    assert items_grouped

    assert_equal 6, items.size

  end


  ########## BLOCK AND UNBLOCK TESTS ##################



  should "unblock the student and not display the block message" do
    student = create(:student, :blocked => true)

    assert student.blocked

    get :unblock, :id => student.id

    assert_redirected_to student
    student.reload

    assert !student.blocked

    get :show, :id => student.id
    assert_select '.blocked .message span', 0

  end

  should "deactivate a student when calling destroy" do
    student = create(:student)

    assert_no_difference "Student.count" do
      post :destroy, id: student.id
    end

    student = assigns(:student)
    assert student.inactive?, "Student should be set to inactive"
  end

  should "reactivate a student" do
    student = create(:student, inactive: false)

    post :reactivate, id: student.id
    student = assigns(:student)
    assert ! student.inactive?, "Student should be active"
    assert_redirected_to student, "Should redirect to student path"
  end


   ####### EMAIL TESTS ############

  should "send out a welcome email" do
    student = create(:student, email: "whatever@whatever.com")

    post :send_welcome_email,  id: student.id

    last_email = ActionMailer::Base.deliveries.last

    assert_equal "whatever@whatever.com", last_email.to.first

    assert_redirected_to student_path(student)
  end

  should "send out a notification email students from item or student screens" do
    student = create(:student, email: "whatever@whatever.com")
    item = create(:item)

    # From Student Screen
    post :notify, students: [student.id], student: student.id
    assert_redirected_to student_path(student), "redirects to student"

    # From Item Screen
    post :notify, students: [student.id], item: item.id
    assert_redirected_to item_path(item), "redirects to item"

    last_email = ActionMailer::Base.deliveries.last
    assert_equal "whatever@whatever.com", last_email.to.first

  end

  should "redirect to item or student path if no student ids were provided" do
    post :notify, student: 1
    assert_response :redirect
    post :notify, item: 1
    assert_response :redirect
  end

  should "redirect to rool url if no student or item id was present" do
    post :notify
    assert_response :redirect
    assert_redirected_to root_url
  end


  ######### SEARCH STUDENTS #######

  should "find students based on name or username and use inactive or active status" do
    create(:student, name: "Terry Jones", username: "terryjones", email: "tj@yorku.ca", inactive: false)
    create(:student, name: "Valmar Garry", username: "vgarry", email: "vg@university.ca", inactive: true)

    get :search, q: "Terry Jones"
    students = assigns(:students)
    assert_equal 1, students.size, "One student found with that name"

    get :search, q: "vgarry"
    students = assigns(:students)
    assert_equal 0, students.size, "No one should be found, since vgarry is inactive"

    get :search, q: "vg@university.ca", inactive: true
    students = assigns(:students)
    assert_equal 1, students.size, "Should find one inactive student"

    get :search, q: "terry", inactive: true
    students = assigns(:students)
    assert_equal 0, students.size, "Should find no student student since Terry is active"

  end


  ######### COMPLETE ORIENTATION ######
  should "complete student orientation field" do
    student = create(:student, name: "Terry Jones", username: "terryjones", email: "tj@yorku.ca", inactive: false)
    student.details.update_attributes(orientation_completed: false, orientation_completed_at: nil)

    get :complete_orientation, id: student.id
    assert_response :redirect
    assert_redirected_to student_path(student), "Should redirect back to student view"

    student.reload

    assert student.details.orientation_completed, "Should be true"
    assert_not_nil student.details.orientation_completed_at, "Should not be nil"

  end

end
