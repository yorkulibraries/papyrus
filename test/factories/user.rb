FactoryGirl.define do
  factory :user do
    sequence(:first_name) { |n| "First #{n}" }
    sequence(:last_name) { |n| "Last #{n}" }
    sequence(:email) { |n| "foo#{n}@email.com" }
    sequence(:username) { |n| "username#{n}" }
    role User::MANAGER
    first_time_login false
    blocked false
  end
end
