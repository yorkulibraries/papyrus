FactoryGirl.define do

  factory :attachment do
    sequence(:name) { |n| "Some Name of Attachment #{n}"}
    full_text false
    file { fixture_file_upload( Rails.root + 'test/fixtures/test_pdf.pdf','application/pdf') }
    association :item, factory: :item
    association :user, factory: :user
    is_url false
    access_code_required false
    url nil

  end

end
