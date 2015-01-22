FactoryGirl.define do

  factory :course do
    sequence(:title) { |n| "Some Type of Course #{n}"}
    sequence(:code) { |n| "SUPER_AWESOME_CODE_#{n}"}
    association :term, :factory => :term
  end

end
