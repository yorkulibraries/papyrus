FactoryGirl.define do


  factory :acquisition_request do
    association :item, factory: :item
    association :requested_by, factory: :student
    association :fulfilled_by, factory: :student
    association :cancelled_by, factory: :student

    fulfilled true
    cancelled false

    requested_by_date  1.month.from_now.to_s(:db)
    fulfilled_by_date  1.month.from_now.to_s(:db)
    cancelled_by_date  1.month.from_now.to_s(:db)

    notes "Some awesome notes"

  end

end
