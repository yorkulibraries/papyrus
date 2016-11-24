require 'test_helper'

class StudentTest < ActiveSupport::TestCase

  should "display current or expired items" do
     student = create(:student)

     create_list(:item_connection, 5, :student => student, :expires_on => Date.today + 1.year)
     create_list(:item_connection, 4, :student => student, :expires_on => Date.today - 1.year)

     assert_equal 5, student.current_items.size
     assert_equal 4, student.expired_items.size
     assert_equal 9, student.items.size
  end


  should "display as current items if expires_on is set to null, or empty" do
    student = create(:student)

    create_list(:item_connection, 5, :student => student, :expires_on => nil)
    create_list(:item_connection, 2, :student => student, :expires_on => Date.today - 1.month)

    assert_equal 5, student.current_items.size

  end

  should "show lab access students only" do
    details = build(:student_details, format_pdf: true)
    create(:student, student_details: details)
    lab_access_student = create(:student)


    assert_equal  2, Student.all.size, "Should be two"
    assert_equal 1, Student.lab_access_only.size, "Should be one"

  end

  should "return true/false for lab access only students" do
    details = build(:student_details, format_pdf: true)
    general_student = create(:student, student_details: details)
    lab_access_student = create(:student)

    assert lab_access_student.lab_access_only?
    assert ! general_student.lab_access_only?
  end

  should "show csv format properly" do

    student = create(:student, name: "test", email: "test@test.com")

    csv = student.to_csv

    assert_equal csv[0], student.id, "id"
    assert_equal csv[1], student.name, "name"
    assert_equal csv[2], student.email, "email"
    assert_equal csv[3], student.student_details.student_number, "student_number"
    assert_equal csv[4], student.student_details.formats.join(", "), "Formarts listed"
    assert_equal csv[5], student.student_details.cds_counsellor, "some person"
    assert_equal csv[6], student.created_at, "created_at"

  end

  should "show only students assigned to a particular user" do
    user = create(:user, role: User::MANAGER)

    create_list(:student_details, 3,  student: create(:student), transcription_coordinator: user)

    # control student
    create_list(:student_details, 2,  student: create(:student), transcription_coordinator: create(:user, role: User::STAFF))

    assert_equal 3, Student.assigned_to(user.id).count, "Students assigned to user"

  end


  ## RETRIEVE item counts, current, expired or all for a group of students - SOLIVNG N+1 ISSUE
  should "return a map of student id and current, expired or all item counts" do
    students = create_list(:student, 4)
    students.each do |student|
      create_list(:item_connection, 10, expires_on: 1.year.from_now, student: student)
      create_list(:item_connection, 5, expires_on: 1.year.ago, student: student)
    end

    current_counts = Student.item_counts(students.collect { |s| s.id }, "current")

    assert_equal 4, current_counts.size, "Should be 4 count entries"
    assert_equal 10, current_counts[students.first.id], "should be 10 current items"

    current_counts = Student.item_counts(students.collect { |s| s.id }, "expired")
    assert_equal 5, current_counts[students.first.id], "should be 5 expired items"

    current_counts = Student.item_counts(students.collect { |s| s.id }, "all")
    assert_equal 15, current_counts[students.first.id], "should be 15 all items"
  end



  should "update fields from array of fields" do
    fields = [
      "student_number", "first_name", "last_name", "email", "cds_counsellor", "cds_counsellor_email","request_form_signed_on",
      "accessibility_lab_access", "book_retrieval", "alternate_format_required", "format_pdf", "format_large_print", "format_braille",
      "format_word", "format_other", "format_note"
    ]


    data = [12323, "Johnny", "Smithy", "johnny@smitthy.com", "Jeremy Irons", "jeremy@irons.com", "2012-10-10", "True", "false", "True",
            "True", "no", "False", "True", "True", "No Notes" ]

    hash = Student.build_hash_from_array(data, fields)

    student = OpenStruct.new(hash)
    student_details = OpenStruct.new(student.student_details_attributes)


    # student
    assert_equal "Johnny", student.first_name
    assert_equal "Smithy", student.last_name
    assert_equal "johnny@smitthy.com", student.email

    # student details
    assert_equal 12323, student_details.student_number, "Student number should be unchanged"
    assert_equal "Jeremy Irons", student_details.cds_counsellor
    assert_equal "jeremy@irons.com", student_details.cds_counsellor_email
    assert_equal "2012-10-10", student_details.request_form_signed_on, "Date should match"
    assert_equal true, student_details.accessibility_lab_access
    assert_equal false, student_details.book_retrieval
    assert_equal true, student_details.alternate_format_required

    # formats
    assert_equal true, student_details.format_pdf, "PDF"
    assert_equal false, student_details.format_large_print, "Large Print"
    assert_equal false, student_details.format_braille, "Braille"
    assert_equal true, student_details.format_word, "World"
    assert_equal true, student_details.format_other, "Other"
    assert_equal "No Notes", student_details.format_note, "notes"

  end

  should "list the most recent students" do
    s1 = create(:student)
    s2 = create(:student)
    s3 = create(:student)


    assert_equal 2, Student.most_recent_students(2).size, "Should be last two students"

    list = Student.most_recent_students(2)

    assert_equal s3.id, list.first.id
    assert_equal s2.id, list.last.id
  end

  should "show never logged in students" do
    create(:student, last_active_at: nil)
    create(:student, last_active_at: 2.days.ago)
    create(:student, last_active_at: 2.days.ago)

    assert_equal 1, Student.never_logged_in.size, "Should be 1"
  end

end
