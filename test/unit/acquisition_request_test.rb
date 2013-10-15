require 'test_helper'

class AcquisitionRequestTest < ActiveSupport::TestCase
  setup do
    @item = Factory.create(:item)
  end
  
  should "create a valid AcquisitionRequest" do
    ar = Factory.build(:acquisition_request, :item => @item)
    
    assert ar.valid?
    assert_difference "AcquisitionRequest.count", 1 do
      ar.save
    end    
  end

  should "not create an Acquisition request with item or requested by fields" do
    ar = Factory.build(:acquisition_request, :item => nil)
    assert !ar.valid?
    
    ar2 = Factory.build(:acquisition_request, :item => @item, :requested_by => nil)
    assert !ar2.valid?

    ar3 = Factory.build(:acquisition_request, :item => @item, :requested_by_date => nil)
    assert !ar3.valid?
        
    assert_no_difference "AcquisitionRequest.count" do
      ar.save
      ar2.save
      ar3.save
    end
    
  end
  
  should "only update fulfilled fields" do
    ar = Factory.create(:acquisition_request, :fulfilled_by => nil, :fulfilled_by_date => false, :cancelled_by_date => false)
    user = Factory.create(:user)  
    
    ar.fulfilled_by = user
    ar.fulfilled_by_date = 1.month.from_now.to_s(:db)
    ar.notes = "notes"
    assert ar.valid?
    
    ar.save
    ar.reload
    
    assert_equal "notes", ar.notes
    assert_equal user.id, ar.fulfilled_by.id
    
  end
  
  should "be able to fulfill request" do
    ar = Factory.create(:acquisition_request, :fulfilled_by => nil, :fulfilled_by_date => false)
    user = Factory.create(:user)
    
    ar.fulfill(user)
    
    ar.reload
    assert ar.fulfilled
    assert_not_nil ar.fulfilled_by_date
    assert_equal user.id, ar.fulfilled_by.id
    
  end
  
  should "not delete, but make AcquisitionRequest cancelled" do
    ar = Factory.create(:acquisition_request)
    user = Factory.create(:user)
    
    assert_no_difference "AcquisitionRequest.count" do
      assert_raise RuntimeError do
        ar.destroy
      end
    end
    
    ar.cancell(user)
    
    ar.reload
    assert_equal true, ar.cancelled, "Cancelled should be true"
    
  end
  
  should "get pending, fulfilled, cancelled requests" do
    Factory.create(:acquisition_request, :fulfilled => false) # pending
    Factory.create(:acquisition_request, :fulfilled => true) # fulfilled
    Factory.create(:acquisition_request, :cancelled => true) # cancelled
    
    assert_equal 1, AcquisitionRequest.pending.size
    assert_equal 1, AcquisitionRequest.fulfilled.size
    assert_equal 1, AcquisitionRequest.cancelled.size        
    
  end
  

  
    
end
