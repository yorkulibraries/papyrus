# frozen_string_literal: true

FactoryGirl.define do
  factory :student_details do
    # partially filled
    sequence(:student_number) { |n| n }
    preferred_phone '12345'
    cds_counsellor 'some person'
    cds_counsellor_email 'counserllor_email@email.com.test'
    student nil
    requires_orientation true
    orientation_completed true
    orientation_completed_at 20.days.ago
    association :transcription_coordinator, factory: :user
    association :transcription_assistant, factory: :user
  end
end
