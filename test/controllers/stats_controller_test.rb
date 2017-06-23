require 'test_helper'

class StatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user, role: User::MANAGER)
    log_user_in(@user)
  end

  should "get total items with attachments" do
    item = create(:item)
    student = create(:student)
    create_list(:attachment, 10, item: item)
    create(:item_connection, item: item, student: student)

    get stats_path

    has_attachments_count = assigns(:has_attachments_count)
    has_students_count = assigns(:has_students_count)

    assert_not_nil has_attachments_count
    assert_not_nil has_students_count

    assert_equal 1, has_attachments_count, "1 attachments"
    assert_equal 1, has_students_count, "1 items assigned to students"

  end

end
