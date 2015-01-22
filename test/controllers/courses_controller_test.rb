require 'test_helper'

class CoursesControllerTest < ActionController::TestCase

    setup do
      @manager_user = create(:user, role: User::MANAGER)
      @term = create(:term)
      @course = create(:course, term: @term)
      log_user_in(@manager_user)
    end

    should "be able to create courses" do
      assert_difference "Course.count", 1 do
        post :create, {:course => attributes_for(:course, :term => @term), :term_id => @term.id }
      end

      assert_redirected_to term_path(@term)
    end

    should "be able to update course" do
      course_title = "some other title"

      course = create(:course, :term => @term)
      course.title = course_title

      post :update, {:id => course.id, :course => { :code => course.code, :title => course.title }, :term_id => @term.id }

      assert_redirected_to term_path(@term)

      c = assigns(:course)
      assert_not_nil c

      assert_equal course_title, c.title

    end

    should "be able to delete course" do
      course = create(:course, :term => @term)
      assert_difference "Course.count", -1 do
        post :destroy, {:id => course.id, :term_id => @term.id}
      end

      assert_redirected_to term_path(@term)
    end

    should "redirect to term details if going to course index" do
        get :index, :term_id => @term.id
        assert_redirected_to term_path(@term)
    end

    should "show template if going to course show" do
      get :show, :term_id => @term.id, :id => 1
      assert_redirected_to term_path(@term)
    end


  ## TEST adding courses to items
  context "adding courses to item" do
    should "be able to add item " do
      item = create(:item)

      assert_difference "ItemCourseConnection.count", 1 do
        post :add_item, :term_id => @term.id, :id => @course.id, :item_id => item.id
      end
      assert_redirected_to courses_item_path(item)
    end


    should "be able to remove an item" do
      item = create(:item)
      @course.add_item (item)

      assert_difference "ItemCourseConnection.count", -1 do
        post :remove_item, :term_id => @term.id, :id => @course.id, :item_id => item.id
        assert_redirected_to courses_item_path(item)
      end
    end

    should "be able to add many courses to one item" do
      course2 = create(:course)
      item = create(:item)


      assert_difference "ItemCourseConnection.count", 2 do
        post :assign_to_item, :term_id => @term.id, :course_ids => "#{@course.id}, #{course2.id}", :item_id => item.id
      end

      assert_redirected_to courses_item_path(item)
    end

    should "fail assign_to_item if teim_id is missing" do

      assert_raise ActiveRecord::RecordNotFound do
        post :assign_to_item, :term_id => @term.id, :course_ids => "[1,2]"
      end
    end

    should "not add duplicate courses" do
      item = create(:item)

      # add two same courses but its should only add one
      assert_difference "ItemCourseConnection.count", 1 do
        post :assign_to_item, :term_id => @term.id, :course_ids => "#{@course.id},#{@course.id}", :item_id => item.id
      end
    end

  end
end
