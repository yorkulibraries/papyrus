# frozen_string_literal: true

require 'test_helper'

class StudentCourseTest < ActiveSupport::TestCase
  should 'list Student Courses' do
    student = create(:student)
    create_list(:student_course, 10, student:)

    assert_equal 10, student.courses.size, 'there are 10 courses'
  end

  should 'not allow duplicate item course connections' do
    student = create(:student)
    course = create(:course)

    course.enroll_student(student)

    assert_no_difference 'StudentCourse.count' do
      course.enroll_student(student)
    end
  end
end
