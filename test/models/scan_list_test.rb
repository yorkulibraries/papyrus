require 'test_helper'

class ScanListTest < ActiveSupport::TestCase

  should "create valid ScanList" do
    scan_list = build(:scan_list)
    assert scan_list.valid?
    assert_difference "ScanList.count", 1 do
      scan_list.save
    end
  end

  should "not create an invalid ScanList"  do

    assert ! build(:scan_list, name: nil).valid?, "name must be present"
    assert ! build(:scan_list, status: nil).valid?, "status Type must be present"

    assert ! build(:scan_list, created_by_id: nil).valid?, "created_by id must be present"
  end

end
