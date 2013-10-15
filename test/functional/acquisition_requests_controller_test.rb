require 'test_helper'

class AcquisitionRequestsControllerTest < ActionController::TestCase
  setup do
     @user = Factory.create(:user, :role => User::ADMIN)
     log_user_in(@user)
  end
  
  should "show pending requests by default" do
    Factory.create(:acquisition_request, :fulfilled => false)
    Factory.create(:acquisition_request, :fulfilled => true)
    
    get :index
    
    requests = assigns(:acquisition_requests)
    assert requests, "No requests have been assigned"
    assert assigns(:filter_title)
    assert_equal "Pending", assigns(:filter_title)
    assert_equal 1, requests.size
    
  end
  
  should "show fulfilled or cancelled requests when either option is specified" do
    Factory.create(:acquisition_request, :fulfilled => false)
    Factory.create(:acquisition_request, :fulfilled => true)
    Factory.create(:acquisition_request, :fulfilled => true)
    Factory.create(:acquisition_request, :cancelled => true)
    Factory.create(:acquisition_request, :cancelled => true)
    Factory.create(:acquisition_request, :cancelled => true)
    
    # fulfilled
    get :index, :which => "fulfilled"
    
    requests = assigns(:acquisition_requests)
    assert requests, "No fulfilled requests"
    assert_equal "Fulfilled", assigns(:filter_title)
    assert_equal 2, requests.size
    
    # cancelled
    get :index, :which => "cancelled"
    
    requests = assigns(:acquisition_requests)
    assert requests, "No cancelled requests"
    assert_equal "Cancelled", assigns(:filter_title)
    assert_equal 3, requests.size
        
  end
  
  
  should "show aquisition request" do
    request = Factory.create(:acquisition_request)
    
    get :show, :id => request.id
    
    assert assigns(:acquisition_request)
    assert_template "show"
    
  end
  
  
  should "not destroy but cancell requests" do
    request = Factory.create(:acquisition_request)
    
    assert_no_difference "AcquisitionRequest.count" do
      post :destroy, :id => request.id
    end
    
    request.reload
    assert request.cancelled
    
    assert_redirected_to acquisition_requests_path
  end
  
  
  should "full fill the request on fulfill" do
    request = Factory.create(:acquisition_request, :fulfilled => false)
    
    post :fulfill, :id => request.id
    
    request.reload
    
    assert_redirected_to acquisition_request_path(request)
    assert assigns(:acquisition_request), "Doesn't assing request"
    
    assert request.fulfilled, "Is not fulfilled" 
    assert_equal @user.id, request.fulfilled_by.id
    
  end
  
  should "only update the notes when updating" do
    
    # FIX THIS TEST
    request = Factory.create(:acquisition_request, :fulfilled => false, :notes => "note")
    
    post :update, :id => request.id, :acquisition_request => {:notes => "note" }
    
    assert_redirected_to acquisition_request_path(request)
    
    assert assigns(:acquisition_request)
    
    request.reload
    assert_equal false, request.fulfilled
    
  end
  
  should "create acquisition request for a specified item" do
    item = Factory.create(:item)
    
    assert_difference "AcquisitionRequest.count", 1 do
      get :for_item, :item_id => item.id
    end
    
    assert assigns(:acquisition_request)    
    assert_redirected_to acquisition_requests_item_path(item)
  end
  
  
  
  
  
  
end
