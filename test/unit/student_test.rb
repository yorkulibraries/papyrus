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


  should "show csv format properly" do
    student = create(:student, name: "test", email: "test@test.com", )

    csv = student.to_csv

    assert_equal csv[0], student.id, "id"
    assert_equal csv[1], student.name, "name"
    assert_equal csv[2], student.email, "email"
    assert_equal csv[3], student.student_details.student_number, "student_number"
    assert_equal csv[4], student.student_details.cds_adviser, "some person"
    assert_equal csv[5], student.created_at, "created_at"

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

end
