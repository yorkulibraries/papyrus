# frozen_string_literal: true

class BibRecord::WorldcatResult
  def self.find_item(id)
    require 'worldcatapi'

    client = WORLDCATAPI::Client.new(key: PapyrusSettings.worldcat_key, debug: false)
    record = client.GetRecord(type: 'oclc', id:)

    record.record || nil
  end

  def self.build_item_from_worldcat_result(record, item_type, id_prefix = 'oclc')
    return if record.nil?

    item = Item.new
    item.item_type = item_type
    item.unique_id = "#{id_prefix}_#{record.id}"
    item.title = record.title
    # item.callnumber = result.callnumber

    item.author = record.author.first

    item.isbn = record.isbn.is_a?(Array) ? record.isbn.join(', ') : record.isbn
    item.publisher = record.publisher
    item.published_date = record.published_date
    item.edition = record.edition
    item.physical_description = record.physical_description

    item
  end
end
