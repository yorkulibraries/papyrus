FactoryGirl.define do

  factory :acquisition_request do
    association :item, factory: :item

    association :requested_by, factory: :user
    association :acquired_by, factory: :user
    association :cancelled_by, factory: :user
    association :back_ordered_by, factory: :user

    acquisition_reason "Don't have a book"
    status nil
    cancellation_reason "Some reason"
    cancelled_at nil
    note nil
    back_ordered_until nil
    back_ordered_reason nil

    acquired_at nil
    acquisition_notes "Got it from some place or other"
    acquisition_source_type "Publisher"
    acquisition_source_name "MacMillan"


  end

end
