require 'test_helper'

class HomeControllerTest < ActionController::TestCase

  setup do
    @current_user = create(:user)
    log_user_in(@current_user)
  end

  should "display index page with assigned students and recently worked on items" do
    student = create(:student)
    details = create(:student_details, student: student, transcription_coordinator: @current_user)

    student2 = create(:student, inactive: true)
    details2 = create(:student_details, student: student2, transcription_coordinator: @current_user)


    get :index

    students = assigns(:students)
    assert_not_nil students, "Should have students array"
  

    #     TEST THIS LATER
    #     item = create(:item)
    #     recently_worked_with_items = assigns(:recently_worked_with_items)
    #     assert_not_nil recently_worked_with_items, "Should have recently worked on items"
    #     assert_equal 1, recently_worked_with_items.count, "1 recently worked on item"
  end


end
