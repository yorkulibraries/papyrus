require 'test_helper'

class DocumentTest < ActiveSupport::TestCase

  should "create a new valid document" do
    document = build(:document)

    assert document.valid?, "Document should be valid"
    assert_difference  "Document.count", 1 do
      document.save
    end

  end

  should "Not create an invalid file document" do

    assert ! build(:document, name: nil).valid?, "Name is required"
    assert ! build(:document, attachment: nil).valid?, "Attachment required"
    assert ! build(:document, attachable_id: nil).valid?, "Attachable ID is required"
    assert ! build(:document, attachable_type: nil).valid?, "Attachable Type is required"

  end
end
