require 'test_helper'


class AttachmentTest < ActiveSupport::TestCase

  should "create a new valid attachment" do
    attachment = build(:attachment, name: "woot", full_text: true, file:  fixture_file_upload('test_pdf.pdf', 'application/pdf') )

    assert attachment.valid?, "Attachment should be valid"
    assert_difference  "Attachment.count", 1 do
      attachment.save
    end

  end

  should "Not create an invalid file attachment" do

    assert ! build(:attachment, file: nil, name: nil, is_url: false).valid?
    assert ! build(:attachment, file: nil, name: "whatever", is_url: false).valid?

  end

  should "not create an invalid url attachment" do
    assert ! build(:attachment, is_url: true, url: nil).valid?, "URL is required"
  end


  should "not delete an attachment when destroy is called, rather it should set the deleted flag" do
    attachment = create(:attachment, file:  fixture_file_upload('test_pdf.pdf', 'application/pdf'))

    assert_no_difference "Attachment.count" do
       attachment.destroy
    end

    assert_equal true, attachment.deleted
  end

  should "list all available attachments and deleted attachments" do
    available =  create_list(:attachment,2, file: fixture_file_upload("#{fixture_path}/test_pdf.pdf", 'application/pdf'))

    #deleted =  create_list(:attachment, 5, file: fixture_file_upload("#{fixture_path}/test_picture.jpg", 'application/pdf'), deleted: true)

    assert_equal 2, Attachment.available.size, "THere should be 2 available"
    #assert_equal 5, Attachment.deleted.size, "There should be 5 deleted"
    #assert_equal 7, Attachment.all.size, "7 al together"
  end



  should "show full_text, and non_full text (available) attachments" do
    full_text = create_list(:attachment, 2, file: fixture_file_upload('test_pdf.pdf', 'application/pdf'), full_text: true)
    #full_text_deleted = create_list(:attachment, 20, file: fixture_file_upload('test_pdf.pdf', 'application/pdf'), full_text: true,  deleted: true)
    #not_full_text = create_list(:attachment, 2, file: fixture_file_upload('test_pdf.pdf', 'application/pdf'), full_text: false)

    assert_equal 2, Attachment.full_text.available.size, "Should be 2 full text available"
    #assert_equal 2, Attachment.not_full_text.available.size, "should be 2 not full text available"
    #assert_equal 20, Attachment.full_text.deleted.size, "should be 20 full_text deleted"
  end


  should "name the file properly and store it in the proper place" do
    item = create(:item, item_type: Item::BOOK, unique_id: "unique_item", title: "title")
    attachment = create(:attachment, file:  fixture_file_upload('test_pdf.pdf', 'application/pdf'), item: item)

    assert attachment.file, "File was saved"
    assert attachment.file.filename.end_with?("-test_pdf.pdf"), "File name should include the timestamp and end with file name"
    assert_equal "/uploads/items/book/#{item.unique_id}/#{attachment.file.filename}", attachment.file.to_s, "Full file path should match"

  end

  should "separate between urls and regular files" do
    create(:attachment, is_url: true, url: "whatever")
    create_list(:attachment, 2, is_url: false)

    assert_equal Attachment.urls.size, 1, "1 URL"
    assert_equal Attachment.files.size, 2, "Two files"
    assert_equal Attachment.all.size, 3, "All together 3"
  end


  def teardown
    Attachment.all.each do |a|
      f = "#{Rails.public_path}#{a.file.to_s}"
      File.delete(f) if File.exist?(f)
      CarrierWave.clean_cached_files! 1
    end
  end
end
