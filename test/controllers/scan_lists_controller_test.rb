require 'test_helper'

class ScanListsControllerTest < ActionDispatch::IntegrationTest

    setup do
      @manager_user = create(:user, role: User::ADMIN)
      log_user_in(@manager_user)
    end


    should "show scan lists" do
      create_list(:scan_list,4)
      create_list(:scan_list, 3, status: ScanList::STATUS_SCANNING)
      create_list(:scan_list, 5, status: ScanList::STATUS_DONE)

      get scan_lists_path
      assert_response :success

      scan_lists = assigns(:scan_lists)


      assert_not_nil scan_lists, "Shouldn't be nil"


      assert_equal 7, scan_lists.size, "Should only be 7, not completed ones"

      get scan_lists_path, params: { which: "done" }
      assert_response :success
      scan_lists = assigns(:scan_lists)
      assert_equal 5, scan_lists.size, "Should be 5 complted"
    end


    should "show new form for scan list" do
      get new_scan_list_path
      assert_response :success
    end

    should "create a new scann_list" do
      assert_difference "ScanList.count", 1 do
        post scan_lists_path, params: { scan_list: { name: "whaterver" } }
        scan_list = assigns(:scan_list)
        assert scan_list, "Scan List was not assigned"
        assert_equal 0, scan_list.errors.size, "There should be no errors, #{scan_list.errors.messages}"
        assert_equal scan_list.created_by, @manager_user, "User should be manager user"
        assert_equal ScanList::STATUS_NEW, scan_list.status, "Status should be new"

        assert_redirected_to scan_list_path(scan_list), "Should redirect back to scan list"
      end
    end

    should "remove an existing scan_list" do
      scan_list = create(:scan_list)

      assert_difference "ScanList.count", -1 do
        delete scan_list_path(scan_list)
        assert_redirected_to scan_lists_path, "Should redirect back to scan_lists"
      end
    end
end
