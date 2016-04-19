require 'test_helper'

class AcquisitionRequestTest < ActiveSupport::TestCase

  should "create a valid acquisition request" do

    i = build(:acquisition_request)

    assert_difference "AcquisitionRequest.count", 1 do
      i.save
    end
  end

  should "not create an invalid acquisition_request" do

    ## blank item
    assert ! build(:acquisition_request, item: nil).valid?
    assert ! build(:acquisition_request, requested_by: nil).valid?

  end

  should "require additional acquired fields if Status is #{AcquisitionRequest::STATUS_ACQUIRED}" do
    status = AcquisitionRequest::STATUS_ACQUIRED
    assert ! build(:acquisition_request, status: status, acquired_by: nil).valid?
    assert ! build(:acquisition_request, status: status, acquired_at: nil).valid?
    assert ! build(:acquisition_request, status: status, acquisition_source_type: nil).valid?
    assert ! build(:acquisition_request, status: status, acquisition_source_name: nil).valid?


    ## save item with field filled in
    i = create(:acquisition_request)
    i.status = AcquisitionRequest::STATUS_ACQUIRED
    i.acquired_by = create(:user)
    i.acquired_at = Time.now
    i.acquisition_source_type = "Publisher"
    i.acquisition_source_name = "MacMillan"

    assert i.save, "Should save without issues on acquisition"
  end

  should "require additional cancelled fields if Status i #{AcquisitionRequest::STATUS_CANCELLED}" do
    status = AcquisitionRequest::STATUS_CANCELLED
    assert ! build(:acquisition_request, status: status, cancelled_by: nil).valid?
    assert ! build(:acquisition_request, status: status, cancelled_at: nil).valid?
    assert ! build(:acquisition_request, status: status, cancellation_reason: nil).valid?

    ## save item with field filled in
    i = create(:acquisition_request)
    i.status = AcquisitionRequest::STATUS_CANCELLED
    i.cancelled_by = create(:user)
    i.cancelled_at = Time.now
    i.cancellation_reason = "Something didn't work, mistake"

    assert i.save, "Should save without issues on cancellation"

  end

  should "retrieve acquisition requests by status (scoped)" do
    create(:acquisition_request)
    create_list(:acquisition_request, 2, status: AcquisitionRequest::STATUS_ACQUIRED, acquired_at: Time.now)
    create_list(:acquisition_request, 3, status: AcquisitionRequest::STATUS_CANCELLED, cancelled_at: Time.now)
    create_list(:acquisition_request, 4, status: AcquisitionRequest::STATUS_BACK_ORDERED, cancelled_at: Time.now)

    assert_equal 3, AcquisitionRequest.cancelled.count
    assert_equal 1, AcquisitionRequest.open.count
    assert_equal 2, AcquisitionRequest.acquired.count
    assert_equal 4, AcquisitionRequest.back_ordered.count

  end

  should "retrieve acquisition requests by source_type" do
    create(:acquisition_request, acquisition_source_type: "Publisher")
    create_list(:acquisition_request, 2, acquisition_source_type: "Student")

    assert_equal 1, AcquisitionRequest.by_source_type("Publisher").count
    assert_equal 2, AcquisitionRequest.by_source_type("Student").count
  end

  should "show available_after as Unknown if nil or as date" do
    unknown = create(:acquisition_request, back_ordered_until: nil)
    date = 3.months.from_now
    known =   create(:acquisition_request, back_ordered_until: date)
  end


end
