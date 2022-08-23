# frozen_string_literal: true

require 'test_helper'

class DocumentTest < ActiveSupport::TestCase
  should 'create a new valid document' do
    document = build(:document)
    create(:document)

    assert document.valid?, 'Document should be valid'
    assert_difference 'Document.count', 1 do
      document.save
    end
  end

  should 'Not create an invalid file document' do
    assert !build(:document, name: nil).valid?, 'Name is required'
    assert !build(:document, attachment: nil).valid?, 'Attachment required'
    assert !build(:document, attachable_id: nil).valid?, 'Attachable ID is required'
    assert !build(:document, attachable_type: nil).valid?, 'Attachable Type is required'
    assert !build(:document, user: nil).valid?, 'User is required'
  end

  should 'list all available documents and deleted documents' do
    available = create_list(:document, 2)
    deleted = create_list(:document, 5, deleted: true)

    assert_equal 2, Document.available.size, 'THere should be 2 available'
    assert_equal 5, Document.deleted.size, 'There should be 5 deleted'
    assert_equal 7, Document.all.size, '7 al together'
  end
end
