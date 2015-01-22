FactoryGirl.define do

  factory :note do
    note "Some notes of sorts"
    association :user, factory: :user
    association :student, factory: :student
  end

end
