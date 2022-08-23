# frozen_string_literal: true

FactoryGirl.define do
  factory :announcement do
    message 'some message'
    ends_at 5.minutes.from_now
    starts_at 2.minutes.ago
    audience Announcement::AUDIENCE_USER
    association :user, factory: :user
    active true
  end
end
