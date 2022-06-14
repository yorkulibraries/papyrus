FactoryGirl.define do

  factory :student, class: Student, parent: :user do
    sequence(:name) { |n| "Some Student #{n}"  }
    role User::STUDENT_USER
    association :created_by, factory: :user
    association :student_details, factory: :student_details
    username { student_details.student_number }
  end

end
