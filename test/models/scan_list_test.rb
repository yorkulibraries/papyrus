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

  should "return assignee and/or creator name" do
    u = create(:user, name: "John Doe")
    scan_list = create(:scan_list, created_by: u, assigned_to: u)

    assert_equal u.name, scan_list.assignee
    assert_equal u.name, scan_list.creator

    scan_list.assigned_to = nil

    assert_equal "Unassigned", scan_list.assignee
  end

  should "Return completed and not completed scan lists" do
    create_list(:scan_list, 3, status: ScanList::STATUS_DONE)
    create_list(:scan_list, 2, status: ScanList::STATUS_NEW)
    create_list(:scan_list, 2, status: ScanList::STATUS_SCANNING)

    assert_equal 4, ScanList.not_completed.size, "Should be 4"
    assert_equal 3, ScanList.completed.size, "Should be 3"
  end


end
