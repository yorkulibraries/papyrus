require 'test_helper'

class CourseTest < ActiveSupport::TestCase

  should "create a valid course" do
    course = build(:course)
    assert course.valid?
    assert_difference "Course.count", 1 do
      course.save
    end
  end

  should "be retrieved ordered alphabetically by default" do
    create(:course, :title => "b")
    create(:course, :title => "c")
    create(:course, :title => "a")

    courses = Course.all
    assert_equal 3, courses.size
    assert_equal courses.first.title, "a"
    assert_equal courses.last.title, "c"
  end



  should "not create a course without a term" do
    course = build(:course, :term => nil)
    assert !course.valid?, "Course is invalid"

    assert_difference "Course.count", 0 do
      course.save
    end

  end

  should "not create/update a course without title or code" do
    course = build(:course, :title => nil)
    assert !course.valid?

    course2 = build(:course, :code => nil)
    assert !course2.valid?
  end

  should "not create a course with a duplicate code" do
    course = create(:course)
    code = course.code

    course_dup = build(:course, :code => code)

    assert !course_dup.valid?
  end


  should "be able to add an item" do
    course = create(:course)
    item = create(:item)

    assert_difference "ItemCourseConnection.count", 1 do
      course.add_item(item)
    end

  end

  should "be able to remove item" do
    course = create(:course)
    item = create(:item)
    course.add_item(item)

    assert_difference "ItemCourseConnection.count", -1 do
      course.remove_item(item)
    end
  end

  should "do nothing if item passed was nil to add or remove item methods" do
    course = create(:course)

    assert_difference "ItemCourseConnection.count", 0 do
      course.add_item(nil)
      course.remove_item(nil)
    end
  end


  should "not add duplicate items" do
    course = create(:course)
    item = create(:item)

    course.add_item(item)

    assert_no_difference "ItemCourseConnection.count" do
      course.add_item(item)
    end
  end


  should "search for courses and ignore courses with expired Terms" do
    active_term = create(:term, :name => "active", :start_date => Date.today, :end_date => Date.today + 1.year)
    expired_term = create(:term, :name => "expired", :start_date => Date.today - 1.year, :end_date => Date.today - 2.months)

    create(:course, :title => "Expired same_string", :term => expired_term, :code => "1")
    create(:course, :title => "Active same_string", :term => active_term, :code => "2")


    assert_equal 0, Course.search("expired").size, "Expired string is in the course with an expired term"
    assert_equal 1, Course.search("Active").size, "Active string is only in the course with an active term"
    assert_equal 1, Course.search("same_string").size, "Both courses have 'same_string' in them, but it should only return 1 course"
    assert_equal "Active same_string", Course.search("Active").first.title, "Make sure it returns the correct course"

  end

  ## Enroll and Withdraw students
  should "be able to enroll student" do
    course = create(:course)
    student = create(:student)

    assert_difference "StudentCourse.count", 1 do
      course.enroll_student(student)
    end

  end

  should "be able to withdraw item" do
    course = create(:course)
    student = create(:student)
    course.enroll_student(student)

    assert_difference "StudentCourse.count", -1 do
      course.withdraw_student(student)
    end
  end

end
