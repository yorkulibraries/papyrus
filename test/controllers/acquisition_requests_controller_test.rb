require 'test_helper'

class AcquisitionRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user, role: User::ADMIN)
    log_user_in(@user)
    @item = create(:item)
  end

  should 'list  acquisition items by status' do
    create_list(:acquisition_request, 3, status: nil)
    create_list(:acquisition_request, 4, status: AcquisitionRequest::STATUS_ACQUIRED, acquired_at: Time.now)
    create_list(:acquisition_request, 2, status: AcquisitionRequest::STATUS_CANCELLED, cancelled_at: Time.now)
    create_list(:acquisition_request, 1, status: AcquisitionRequest::STATUS_BACK_ORDERED)

    get acquisition_requests_url
    assert_response :success
    items = assigns(:acquisition_requests)
    assert_equal 3, items.size, '3 Open acquisition requests'
  end

  should 'list acquistions items when status is specified' do
    create_list(:acquisition_request, 3, status: nil)
    create_list(:acquisition_request, 4, status: AcquisitionRequest::STATUS_ACQUIRED, acquired_at: Time.now)
    create_list(:acquisition_request, 2, status: AcquisitionRequest::STATUS_CANCELLED, cancelled_at: Time.now)
    create_list(:acquisition_request, 1, status: AcquisitionRequest::STATUS_BACK_ORDERED)

    get status_acquisition_requests_url, params: { status: AcquisitionRequest::STATUS_ACQUIRED }
    assert_response :success
    reqs = assigns(:acquisition_requests)
    assert_equal 4, reqs.size, '4 STATUS_ACQUIRED acquisition requests'

    get status_acquisition_requests_url, params: { status: AcquisitionRequest::STATUS_BACK_ORDERED }
    assert_response :success
    reqs = assigns(:acquisition_requests)
    assert_equal 1, reqs.size, '4 STATUS_BACK_ORDERED acquisition requests'

    get status_acquisition_requests_url
    assert_redirected_to acquisition_requests_path
  end

  should 'show acquisition_request details' do
    ar = create(:acquisition_request)

    get acquisition_request_url(ar)
    assert_response :success
  end

  ### CREATING ###

  should 'show new acquistion request' do
    item = create(:item)
    get new_acquisition_request_url, params: { item_id: item.id }
    assert_response :success

    assert assigns(:item), 'Should load an request for which to create an acquisition'
  end

  should 'create a new acquisition request' do
    item = create(:item)
    assert_difference('AcquisitionRequest.count') do
      ai = build(:acquisition_request, item:)
      post acquisition_requests_url, params: { acquisition_request: ai.attributes }

      request = assigns(:acquisition_request)
      assert request
      assert_equal 0, request.errors.size, "Should be no errors, #{request.errors.messages}"
      assert_redirected_to acquisition_request_path(request)
    end
  end

  ### EDITING ###

  should 'show edit form' do
    ar = create(:acquisition_request, item_id: @item.id)

    get edit_acquisition_request_url(ar)
    assert_response :success
  end

  should 'update an existing acquisition_request' do
    ar = create(:acquisition_request)
    old_source_type = ar.acquisition_source_type

    patch acquisition_request_url(ar), params: { acquisition_request: { acquisition_source_type: 'NEW' } }
    acquisition_request = assigns(:acquisition_request)
    assert_equal 0, acquisition_request.errors.size, "Should be no errors, #{acquisition_request.errors.messages}"
    assert_response :redirect
    assert_redirected_to acquisition_request_path(acquisition_request)

    assert_not_equal old_source_type, acquisition_request.acquisition_source_type, 'Old source type is not there'
    assert_equal 'NEW', acquisition_request.acquisition_source_type, 'Source Type was updated'
  end

  should 'destroy an existing acquisition item' do
    ar = create(:acquisition_request)
    assert_difference('AcquisitionRequest.count', -1) do
      delete acquisition_request_url(ar)
    end

    assert_redirected_to acquisition_requests_path
  end

  ### STATUS CHANGES ###
  should "set status to #{AcquisitionRequest::STATUS_ACQUIRED}" do
    ar = create(:acquisition_request)
    source_type = 'Publisher'
    source_name = 'Penguin'

    patch change_status_acquisition_request_url(ar), params: { status: AcquisitionRequest::STATUS_ACQUIRED,
                                                               acquisition_request: {
                                                                 acquisition_source_type: source_type, acquisition_source_name: source_name
                                                               } }

    acquisition_request = assigns(:acquisition_request)
    assert_response :redirect
    assert_redirected_to acquisition_request_path(acquisition_request)

    assert acquisition_request, 'Request was loaded'
    assert_equal AcquisitionRequest::STATUS_ACQUIRED, acquisition_request.status, 'Status should be acquired'
    assert_equal source_type, acquisition_request.acquisition_source_type
    assert_equal source_name, acquisition_request.acquisition_source_name

    assert_equal @user.id, acquisition_request.acquired_by.id, 'Records who acquired it'
    assert_not_nil acquisition_request.acquired_at, 'Date and time acquired should set'
    assert_equal Date.today, acquisition_request.acquired_at.to_date, 'Should be today'
  end

  should "set status to #{AcquisitionRequest::STATUS_CANCELLED}" do
    ar = create(:acquisition_request)
    reason = 'Duplicate'

    patch change_status_acquisition_request_url(ar), params: {
      status: AcquisitionRequest::STATUS_CANCELLED,
      acquisition_request: { cancellation_reason: reason }
    }

    acquisition_request = assigns(:acquisition_request)
    assert_response :redirect
    assert_redirected_to acquisition_request_path(acquisition_request)

    assert acquisition_request, 'Request was loaded'
    assert_equal AcquisitionRequest::STATUS_CANCELLED, acquisition_request.status, 'Status should be cancelled'
    assert_equal reason, acquisition_request.cancellation_reason

    assert_equal @user.id, acquisition_request.cancelled_by.id, 'Records who cancelled it'
    assert_not_nil acquisition_request.cancelled_at, 'Date and time cancelled should set'
    assert_equal Date.today, acquisition_request.cancelled_at.to_date, 'Should be today'
  end

  should "set status to #{AcquisitionRequest::STATUS_BACK_ORDERED}" do
    ar = create(:acquisition_request)
    date = 3.weeks.from_now

    patch change_status_acquisition_request_url(ar), params: { status: AcquisitionRequest::STATUS_BACK_ORDERED,
                                                               acquisition_request: { back_ordered_until: date } }

    acquisition_request = assigns(:acquisition_request)
    assert_response :redirect
    assert_redirected_to acquisition_request_path(acquisition_request)

    assert acquisition_request, 'Request was loaded'
    assert_equal AcquisitionRequest::STATUS_BACK_ORDERED, acquisition_request.status, 'Status should be back_ordered'
    assert_equal date.to_date, acquisition_request.back_ordered_until
  end
end
