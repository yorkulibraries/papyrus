FactoryGirl.define do
  factory :item_course_connection do
    association :item, factory: :item
    association :course, factory: :course
  end
end
