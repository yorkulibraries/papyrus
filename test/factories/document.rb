FactoryGirl.define do

  factory :document do
    sequence(:name) { |n| "Some Name of Attachment #{n}"}
    attachments { fixture_file_upload( Rails.root + 'test/fixtures/test_pdf.pdf','application/pdf') }
    association :attachable, factory: :student
    association :user, factory: :user

    deleted false
  end

end
