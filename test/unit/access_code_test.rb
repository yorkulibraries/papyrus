require 'test_helper'

class AccessCodeTest < ActiveSupport::TestCase

  should "create a valid access_code" do 
    assert_difference "AccessCode.count", 1 do
      access_code = build(:access_code)
      access_code.save
    end  
  end 
  
  should "not create an invalid access_code" do
    assert ! build(:access_code, student: nil).valid?, "Student is required"
    assert ! build(:access_code, created_by: nil).valid?, "Created By is required"    
    assert ! build(:access_code, for: nil).valid?, "For is required"
    assert ! build(:access_code, code: nil).valid?, "Code is required"    
  end
  
  should "show expired and active access codes" do
    create_list(:access_code, 2, expires_at: 2.days.ago)
    create_list(:access_code, 3, expires_at: 2.days.from_now)   
    create_list(:access_code, 2, expires_at: nil) 
    
    assert_equal 2, AccessCode.expired.size, "2 Expired"
    assert_equal 5, AccessCode.active.size, "3 active"
    
  end
  
end
