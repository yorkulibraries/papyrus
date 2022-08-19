FactoryGirl.define do
  factory :access_code do
    sequence(:for) { |_n| 'Access Code' }
    code 'some code'
    shared false
    expires_at 1.month.from_now
    association :student, factory: :student
    association :created_by, factory: :user
  end
end
