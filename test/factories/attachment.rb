# frozen_string_literal: true

FactoryGirl.define do
  factory :attachment do
    sequence(:name) { |n| "Some Name of Attachment #{n}" }
    full_text false
    file { Rack::Test::UploadedFile.new('test/fixtures/test_pdf.pdf') }
    association :item, factory: :item
    association :user, factory: :user
    is_url false
    access_code_required false
    url nil
  end
end
