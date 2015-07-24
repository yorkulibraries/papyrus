require "ostruct"

class BibRecord

  ## CONSTANTS
  SOLR = "solr"
  WORLDCAT = "worldcat"


  def initialize()
    
  end


  ## COMMON INTERFACE
  def search_items(search_string, source = SOLR)

    if source == SOLR
      search_solr_items(search_string)
    elsif source == WORLDCAT
      search_worldcat_items(search_string)
    else
      ["No Results Found"]
    end
  end

  def find_item(item_id, source = SOLR)
    if source == SOLR
      find_solr_item(item_id)
    elsif source == WORLDCAT
      find_worldcat_item(item_id)
    else
      "Record Not Found"
    end
  end

  def build_item_from_search_result(result, item_type, source = SOLR)
    if source == SOLR
      BibRecord.build_item_from_solr_result(result, item_type, PapyrusSettings.solr_id_prefix)
    elsif source == WORLDCAT
      BibRecord.build_item_from_worldcat_result(result, item_type, PapyrusSettings.worldcat_id_prefix)
    else
      "Item Can't be built"
    end
  end
  ## SOLR SPECIFIC METHODS

  def search_solr_items(query)
    require 'solr'
    solr = Solr::Connection.new(PapyrusSettings.solr_url)

    query_fields = "title_short_txtP^757.5   title_short^750  title_full_unstemmed^404   title_full^400   title_txtP^750   title^500   title_alt_txtP_mv^202   title_alt^200   title_new_txtP_mv^101   title_new^100   series^50   series2^30   author^500   author_fuller^150   contents^10   topic_unstemmed^404   topic^400   geographic^300   genre^300   allfields_unstemmed^10   fulltext_unstemmed^10   allfields isbn issn"
    phrase_fields = "title_txtP^100"
    boost_functions = "recip(ms(NOW,publishDateBoost_tdate),3.16e-11,1,1)^1.0"
    sort = [ {score: :descending}, {_docid_: :descending} ]

    unless query.blank?
      response = solr.search("#{query}", sort: sort, query_fields: query_fields, debug_query:  true, phrase_fields: phrase_fields, boost_functions: boost_functions)
      #$config_logger.debug("HERE  #{JSON.parse(response.raw_response)}")
      results = response.hits
    else
      Array.new
    end

  end

  def find_solr_item(item_id)
    require 'solr'
    solr = Solr::Connection.new(PapyrusSettings.solr_url)
    result = solr.query("id: #{item_id}")

    if result.hits.first
      result.hits.first
    else
      nil
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

  def self.build_item_from_solr_result(result, item_type, id_prefix = SOLR)
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
