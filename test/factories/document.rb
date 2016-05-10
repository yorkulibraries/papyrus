FactoryGirl.define do

  factory :document do
    sequence(:name) { |n| "Some Name of Attachment #{n}"}
    attachment { fixture_file_upload( Rails.root + 'test/fixtures/test_pdf.pdf','application/pdf') }
    attachable { |a| a.association(:student) }    
    association :user, factory: :user

    deleted false
  end

end
