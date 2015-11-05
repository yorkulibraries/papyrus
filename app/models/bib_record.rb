require "ostruct"

class BibRecord

  ## CONSTANTS
  VUFIND = "vufind"
  WORLDCAT = "worldcat"


  def initialize()

  end


  ## COMMON INTERFACE
  def search_items(search_string, source = VUFIND)

    if source == VUFIND
      search_vufind_items(search_string)
    elsif source == WORLDCAT
      search_worldcat_items(search_string)
    else
      ["No Results Found"]
    end
  end

  def find_item(item_id, source = VUFIND)
    if source == VUFIND
      find_vufind_item(item_id)
    elsif source == WORLDCAT
      find_worldcat_item(item_id)
    else
      "Record Not Found"
    end
  end

  def build_item_from_search_result(result, item_type, source = VUFIND)
    if source == VUFIND
      BibRecord.build_item_from_vufind_result(result, item_type, PapyrusSettings.vufind_id_prefix)
    elsif source == WORLDCAT
      BibRecord.build_item_from_worldcat_result(result, item_type, PapyrusSettings.worldcat_id_prefix)
    else
      "Item Can't be built"
    end
  end

  def search_vufind_items(query = "")

    query = "" if query == nil

    # CRUD ISBN search
    if query =~ /[0-9|x]{8}/i || query =~ /[0-9|x]{10}/i || query =~ /[0-9|x]{13}/i
      type = "type=ISN&"
    else
      type = ""
    end

    url = "#{PapyrusSettings.vufind_url}?#{type}json=true&view=rss&lookfor=#{URI.encode(query.squish)}"
    results = JSON.load(open(url))

    if results.size > 0
      return results
    else
      return Array.new
    end
  end


  def find_vufind_item(item_id)
    query = "id:#{item_id}"

    url = "#{PapyrusSettings.vufind_url}?json=true&view=rss&lookfor=#{URI.encode(query.squish)}"
    results = JSON.load(open(url))

    if results.size > 0
      return results.first
    else
      return Array.new
    end
  end


  ## WORLDCAT SPECIFIC METHODS
  def search_worldcat_items(query)
    require 'worldcatapi'

    client = WORLDCATAPI::Client.new(key: PapyrusSettings.worldcat_key, debug: false)
    response = client.SRUSearch(query: "\"#{query}\"")

    if response.records.size > 0
      response.records
    else
      Array.new
    end
  end

  def find_worldcat_item(item_id)
    require 'worldcatapi'

    client = WORLDCATAPI::Client.new(key: PapyrusSettings.worldcat_key, debug: false)
    record = client.GetRecord(type: "oclc", id: item_id)

    if record.record
      record.record
    else
      nil
    end
  end

  def self.build_item_from_vufind_result(result, item_type, id_prefix = VUFIND)
    return if result == nil

    result = HashWithIndifferentAccess.new(result)
    item = Item.new

    item.item_type = item_type
    item.unique_id = "#{id_prefix}_#{result["id"]}"
    item.title = result["title"]
    item.callnumber = result["callnumber"]

    item.author = result["author"]
    item.author = array_or_string(result, "author2") if item.author.blank?

    item.isbn =  array_or_string(result, "isbn")
    item.publisher = array_or_string(result, "publisher")
    item.published_date = array_or_string(result, "publishDate")
    item.edition = array_or_string(result, "edition")
    item.physical_description = array_or_string(result, "physical")
    item.language_note = array_or_string(result, "language")

    item
  end

  def self.build_item_from_worldcat_result(record, item_type, id_prefix = "oclc")
    return if record == nil

    item = Item.new
    item.item_type = item_type
    item.unique_id = "#{id_prefix}_#{record.id}"
    item.title = record.title
    # item.callnumber = result.callnumber

    item.author = record.author.first

    item.isbn = record.isbn.kind_of?(Array) ? record.isbn.join(", ") : record.isbn
    item.publisher = record.publisher
    item.published_date = record.published_date
    item.edition = record.edition
    item.physical_description = record.physical_description


    item

  end

  private

  def self.array_or_string(result, field_name)
    return "" unless result[field_name]

    if result[field_name].kind_of? Array
      result[field_name].join(", ")
    else
      result[field_name]
    end
  end


end
