# frozen_string_literal: true

FactoryGirl.define do
  factory :item do
    # :title, :unique_id, :item_type, :callnumber, :author, :isbn, :publisher, :published_date, :language_note, :edition, :physical_description
    sequence(:title) { |n| "Some Title #{n}"  }
    sequence(:unique_id) { |n| "unique_#{n}"  }
    callnumber 'DF 589 HJ 3989'
    author 'Some Author'
    isbn 1_234_545_345
    publisher 'Some Publisher'
    published_date Date.today.to_s
    language_note 'Some language note'
    edition '3rd Ed.'
    physical_description 'Hwat'
    item_type Item::BOOK
    # subdomain { "#{name.downcase.gsub(" ", "_")}" }
    association :user, factory: :user
  end
end
