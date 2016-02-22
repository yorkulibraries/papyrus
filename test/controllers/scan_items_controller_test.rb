require 'test_helper'

class ScanItemsControllerTest < ActionController::TestCase
  setup do
    @manager_user = create(:user, role: User::ADMIN)
    log_user_in(@manager_user)
    @scan_list = create(:scan_list)
    @item = create(:item)

  end

  should "show new form for scan item" do
    get :new, format: :js, scan_list_id: @scan_list.id
    assert_template :new
  end

  should "create a new scann_list" do
    assert_difference "ScanItem.count", 1 do
      post :create, format: :js, scan_list_id: @scan_list.id, scan_item: { summary: "whaterver", item_id: @item.id }
      scan_item = assigns(:scan_item)
      assert scan_item, "Scan List was not assigned"
      assert_equal 0, scan_item.errors.size, "There should be no errors, #{scan_item.errors.messages}"
      assert_equal scan_item.created_by, @manager_user, "User should be manager user"
      assert_equal scan_item.item.id, @item.id, "Items should match"
      assert_equal scan_item.scan_list.id, @scan_list.id, "Scan Lists should match"
      assert_equal ScanItem::STATUS_NEW, scan_item.status, "Status should be new"

      assert_template :create
    end
  end

  should "remove an existing scan_list" do
    scan_item = create(:scan_item, scan_list_id: @scan_list.id)

    assert_difference "ScanItem.count", -1 do
      post :destroy, scan_list_id: @scan_list.id, id: scan_item.id, format: :js
      assert_template :destroy
    end
  end

end
