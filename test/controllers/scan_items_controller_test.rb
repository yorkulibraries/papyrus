require 'test_helper'

class ScanItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @manager_user = create(:user, role: User::ADMIN)
    log_user_in(@manager_user)
    @scan_list = create(:scan_list)
    @item = create(:item)

  end

  should "show new form for scan item" do
    get new_scan_list_scan_item_path(@scan_list), xhr: true
    assert_response :success
  end

  should "create a new scann_list" do
    assert_difference "ScanItem.count", 1 do
      post scan_list_scan_items_path(@scan_list),xhr: true, params: { scan_item: { summary: "whaterver", item_id: @item.id } }
      scan_item = assigns(:scan_item)
      assert scan_item, "Scan List was not assigned"
      assert_equal 0, scan_item.errors.size, "There should be no errors, #{scan_item.errors.messages}"
      assert_equal scan_item.created_by, @manager_user, "User should be manager user"
      assert_equal scan_item.item.id, @item.id, "Items should match"
      assert_equal scan_item.scan_list.id, @scan_list.id, "Scan Lists should match"
      assert_equal ScanItem::STATUS_NEW, scan_item.status, "Status should be new"

      assert_response :success
    end
  end

  should "remove an existing scan_list" do
    scan_item = create(:scan_item, scan_list_id: @scan_list.id)

    assert_difference "ScanItem.count", -1 do
      delete scan_list_scan_item_path(@scan_list, scan_item), xhr: true
      assert_response :success
    end
  end

end
