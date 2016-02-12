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

      assert ! build(:scan_item, summary: nil).valid?, "summary must be present"
      assert ! build(:scan_item, status: nil).valid?, "status must be present"
      assert ! build(:scan_item, item: nil).valid?, "item must be present"
      assert ! build(:scan_item, scan_list: nil).valid?, "scan List must be present"

      assert ! build(:scan_item, created_by_id: nil).valid?, "created_by id must be present"
    end
end
