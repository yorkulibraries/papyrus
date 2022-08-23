# frozen_string_literal: true

require 'test_helper'

class CoursesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @manager_user = create(:user, role: User::MANAGER)
    @term = create(:term)
    @course = create(:course, term: @term)
    log_user_in(@manager_user)
  end

  should 'be able to create courses' do
    assert_difference 'Course.count', 1 do
      post term_courses_url(@term), params: { course: attributes_for(:course) }
    end

    assert_redirected_to term_path(@term)
  end

  should 'be able to update course' do
    course_title = 'some other title'

    course = create(:course, term: @term, title: 'test')

    patch term_course_url(@term, course), params: { course: { title: course_title } }

    assert_redirected_to term_path(@term)

    c = assigns(:course)
    assert_not_nil c

    assert_equal course_title, c.title
  end

  should 'be able to delete course' do
    course = create(:course, term: @term)
    assert_difference 'Course.count', -1 do
      delete term_course_url(@term, course)
    end

    assert_redirected_to term_path(@term)
  end

  should 'redirect to term details if going to course index' do
    get term_courses_url(@term)
    assert_redirected_to term_path(@term)
  end

  should 'show template if going to course show' do
    get term_course_url(@term, 1)
    assert_redirected_to term_path(@term)
  end

  ## TEST adding courses to items
  context 'adding courses to item' do
    should 'be able to add item ' do
      item = create(:item)

      assert_difference 'ItemCourseConnection.count', 1 do
        post add_item_term_course_path(@term, @course), params: { item_id: item.id }
      end
      assert_redirected_to item_path(item)
    end

    should 'be able to remove an item' do
      item = create(:item)
      @course.add_item(item)

      assert_difference 'ItemCourseConnection.count', -1 do
        post remove_item_term_course_url(@term, @course), params: { item_id: item.id }
        assert_redirected_to item_path(item)
      end
    end

    should 'be able to add many courses to one item' do
      course2 = create(:course)
      item = create(:item)

      assert_difference 'ItemCourseConnection.count', 2 do
        post assign_to_item_term_courses_path(@term),
             params: { course_ids: "#{@course.id}, #{course2.id}", item_id: item.id }
      end

      assert_redirected_to item_path(item)
    end

    should 'fail assign_to_item if teim_id is missing' do
      assert_raise ActiveRecord::RecordNotFound do
        post assign_to_item_term_courses_path(@term), params: { course_ids: '[1,2]' }
      end
    end

    should 'not add duplicate courses' do
      item = create(:item)

      # add two same courses but its should only add one
      assert_difference 'ItemCourseConnection.count', 1 do
        post assign_to_item_term_courses_path(@term),
             params: { course_ids: "#{@course.id},#{@course.id}", item_id: item.id }
      end
    end
  end
end
