require 'test_helper'

class ScanListsControllerTest < ActionController::TestCase

    setup do
      @manager_user = create(:user, role: User::ADMIN)
      log_user_in(@manager_user)
    end


    should "show scan lists" do
      create_list(:scan_list,4)
      create_list(:scan_list, 3, status: ScanList::STATUS_SCANNING)
      create_list(:scan_list, 5, status: ScanList::STATUS_DONE)

      get :index
      assert_template :index

      scan_lists = assigns(:scan_lists)


      assert_not_nil scan_lists, "Shouldn't be nil"


      assert_equal 12, scan_lists.size, "Should only be 12"
    end


    should "show new form for scan list" do
      get :new
      assert_template :new
    end

    should "create a new scann_list" do
      assert_difference "ScanList.count", 1 do
        post :create, scan_list: { name: "whaterver" }
        scan_list = assigns(:scan_list)
        assert scan_list, "Scan List was not assigned"
        assert_equal 0, scan_list.errors.size, "There should be no errors, #{scan_list.errors.messages}"
        assert_equal scan_list.created_by, @manager_user, "User should be manager user"
        assert_equal ScanList::STATUS_NEW, scan_list.status, "Status should be new"

        assert_redirected_to scan_lists_path, "Should redirect back to scan list"
      end
    end

    should "remove an existing scan_list" do
      scan_list = create(:scan_list)

      assert_difference "ScanList.count", -1 do
        post :destroy, id: scan_list.id
        assert_redirected_to scan_lists_path, "Should redirect back to scan_lists"
      end
    end
end
