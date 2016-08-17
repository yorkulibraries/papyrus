require 'test_helper'

class ScanItemTest < ActiveSupport::TestCase
    setup do
      @scan_list = create(:scan_list)
      @item = create(:item)
    end
    should "create valid ScanItem" do
      scan_item = build(:scan_item, scan_list: @scan_list, item: @item)
      assert scan_item.valid?
      assert_difference "ScanItem.count", 1 do
        scan_item.save
      end
    end

    should "not create an invalid ScanItem"  do
      
      assert ! build(:scan_item, status: nil).valid?, "status must be present"
      assert ! build(:scan_item, item: nil).valid?, "item must be present"
      assert ! build(:scan_item, scan_list: nil).valid?, "scan List must be present"

      assert ! build(:scan_item, created_by_id: nil).valid?, "created_by id must be present"
    end

    should "Return completed and not completed scan lists" do
      create_list(:scan_item, 3, status: ScanItem::STATUS_DONE)
      create_list(:scan_item, 4, status: ScanItem::STATUS_NEW)


      assert_equal 4, ScanItem.not_completed.size, "Should be 4"
      assert_equal 3, ScanItem.completed.size, "Should be 3"
    end
end
