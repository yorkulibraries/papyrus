# frozen_string_literal: true

FactoryGirl.define do
  factory :item_connection do
    expires_on 1.year.from_now.to_fs(:db)
    association :item, factory: :item
    association :student, factory: :student
  end
end
