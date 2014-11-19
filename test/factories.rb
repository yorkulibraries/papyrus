FactoryGirl.define do
  factory :item do
    # :title, :unique_id, :item_type, :callnumber, :author, :isbn, :publisher, :published_date, :language_note, :edition, :physical_description
    sequence(:title) { |n| "Some Title #{n}"  }
    sequence(:unique_id) { |n| "unique_#{n}"  }
    callnumber "DF 589 HJ 3989"
    author "Some Author"
    isbn 1234545345
    publisher "Some Publisher"
    published_date Date.today.to_s
    language_note "Some language note"
    edition "3rd Ed."
    physical_description "Hwat"
    item_type Item::BOOK
    #subdomain { "#{name.downcase.gsub(" ", "_")}" }
    association :user, factory: :user
  end

  factory :item_connection do
     expires_on  1.year.from_now.to_s(:db)
     association :item, factory: :item
     association :student, factory: :student
  end

  factory :item_course_connection do
    association :item, factory: :item
    association :course, factory: :course
  end

  factory :user do
    sequence(:name) { |n| "Some User #{n}"  }
    sequence(:email) { |n| "foo#{n}@email.com" }
    sequence(:username) { |n| "username#{n}" }
    role User::MANAGER

  end

  factory :student, class: Student, parent: :user do
     sequence(:name) { |n| "Some Student #{n}"  }
     role User::STUDENT_USER
     association :created_by, factory: :user
     association :student_details, factory: :student_details
   end

  factory :student_details do
    # partially filled
    student_number 12343
    preferred_phone "12345"
    cds_counsellor "some person"
    student nil
    requires_orientation true
    orientation_completed true
    orientation_completed_at 20.days.ago
    association :transcription_coordinator, factory: :user
    association :transcription_assistant, factory: :user

  end

  factory :term do
    sequence(:name) { |n| "Some Term #{n}"}
    start_date 1.month.from_now.to_s(:db)
    end_date 1.year.from_now.to_s(:db)
  end

  factory :course do
    sequence(:title) { |n| "Some Type of Course #{n}"}
    sequence(:code) { |n| "SUPER_AWESOME_CODE_#{n}"}
    association :term, :factory => :term
  end


  factory :note do
    note "Some notes of sorts"
    association :user, factory: :user
    association :student, factory: :student
  end

  factory :acquisition_request do
    association :item, factory: :item
    association :requested_by, factory: :student
    association :fulfilled_by, factory: :student
    association :cancelled_by, factory: :student

    fulfilled true
    cancelled false

    requested_by_date  1.month.from_now.to_s(:db)
    fulfilled_by_date  1.month.from_now.to_s(:db)
    cancelled_by_date  1.month.from_now.to_s(:db)

    notes "Some awesome notes"

  end

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

  factory :access_code do
    sequence(:for) { |n| "Access Code"}
    code "some code"
    shared false
    expires_at 1.month.from_now
    association :student, factory: :student
    association :created_by, factory: :user
  end

end
