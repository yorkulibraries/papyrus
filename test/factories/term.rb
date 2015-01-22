FactoryGirl.define do

  factory :term do
    sequence(:name) { |n| "Some Term #{n}"}
    start_date 1.month.from_now.to_s(:db)
    end_date 1.year.from_now.to_s(:db)
  end

end
