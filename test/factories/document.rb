FactoryGirl.define do
  factory :document do
    sequence(:name) { |n| "Some Name of Attachment #{n}" }
    attachment { Rack::Test::UploadedFile.new(Rails.root + 'test/fixtures/test_pdf.pdf') }
    attachable { |a| a.association(:student) }
    association :user, factory: :user

    deleted false
  end
end
