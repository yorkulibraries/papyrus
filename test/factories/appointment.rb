FactoryGirl.define do
  factory :appointment do
    title 'Orientation'
    note 'Something is recorded'
    at 3.months.from_now
    association :user, factory: :user
    association :student, factory: :student
    completed false
  end
end
