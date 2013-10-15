require 'test_helper'

class StatsControllerTest < ActionController::TestCase
  setup do 
    @user = create(:user, role: User::MANAGER)
    log_user_in(@user)
  end
  
  should "get total items with attachments" do
    item = create(:item)
    student = create(:student)
    create_list(:attachment, 10, item: item)
    create(:item_connection, item: item, student: student)
    
    get :index
    
    has_attachments_count = assigns(:has_attachments_count)
    has_students_count = assigns(:has_students_count)
    
    assert_not_nil has_attachments_count
    assert_not_nil has_students_count
    
    assert_equal 1, has_attachments_count, "1 attachments"
    assert_equal 1, has_students_count, "1 items assigned to students"

  end
  
  should "generate a csv report based on assigned_to" do
    user = create(:user)
    student = create(:student)
    details = create(:student_details, student: student, transcription_coordinator: user, cds_adviser: "tom")
    
    get :generate, assigned_to: user.id
    
    title = assigns(:title)
    results = assigns(:results)
    
    assert_not_nil title, "Title should be set"
    assert_equal 1, results.count, "Should generate one result"
    
    
    get :generate
    
    results = assigns(:results)
    assert_equal 0, results.count, "No results since no assigned to id was passed"
  end
end
