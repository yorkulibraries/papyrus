FactoryGirl.define do
  factory :student_course do
    association :student, factory: :student
    association :course, factory: :course
  end
end
