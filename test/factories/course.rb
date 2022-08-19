FactoryGirl.define do
  factory :course do
    sequence(:title) { |n| "Some Type of Course #{n}" }
    sequence(:code, 3000) { |n| "2016_AP_ADMN_W_#{n}__6_C_EN_A" }
    association :term, factory: :term
  end
end
