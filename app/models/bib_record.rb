require "ostruct"

class BibRecord
  attr_reader :type, :config
  
  ## CONSTANTS
  SOLR = "solr"
  WORLDCAT = "worldcat"
  
  def initialize(config)
      
    @config = config || OpenStruct.new
    @config.type = config.nil? || config.type.blank? ? SOLR : config.type # default to Solr
    @type = @config.type
      
    ensure_config_defaults
  end
  
  
  ## COMMON INTERFACE
  def search_items(search_string)
   
    if @config.type == SOLR
      search_solr_items(search_string)
    elsif @config.type == WORLDCAT
      search_worldcat_items(search_string)
    else
      ["No Results Found"]
    end
  end
  
  def find_item(item_id)
    if @config.type == SOLR
      find_solr_item(item_id)
    elsif @config.type == WORLDCAT
      find_worldcat_item(item_id)
    else
      "Record Not Found"
    end
  end
  
  def build_item_from_search_result(result, item_type)
    if @config.type == SOLR
      BibRecord.build_item_from_solr_result(result, item_type, @config.id_prefix)
    elsif @config.type == WORLDCAT
      self.build_item_from_worldcat_result(result, item_type, @config.id_prefix)
    else
      "Item Can't be built"
    end
  end
  ## SOLR SPECIFIC METHODS
  
  def search_solr_items(query)
    require 'solr'
    solr = Solr::Connection.new(@config.url)
  
    query_fields = @config.query_fields
    phrase_fields = @config.phrase_fields
    boost_functions = @config.boost_functions
    sort = @config.sort

    $logger.debug @config.url
    $logger.debug @config.label
    
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
    solr = Solr::Connection.new(@config.url)
    result = solr.query("id: #{item_id}")
    
    if result.hits.first 
      result.hits.first 
    else
      nil
    end    
  end
  
  def self.build_item_from_solr_result(result, item_type, id_prefix = "solr")
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
  
  private 
 
  def self.array_or_string(result, field_name)
    return "" unless result[field_name] 
    
    if result[field_name].kind_of? Array 
      result[field_name].join(", ")
    else
      result[field_name]
    end
  end 
  
  def ensure_config_defaults
    if @config.type == SOLR
      
      @config.label = @config.label || "DEFAULT_SOLR"
      @config.id_prefix = @config.id_prefix || "default_solr"
      @config.url = @config.url || "http://localhost:8080/solr/biblio"
      @config.query_fields = @config.query_fields || "title_short_txtP^757.5   title_short^750  title_full_unstemmed^404   title_full^400   title_txtP^750   title^500   title_alt_txtP_mv^202   title_alt^200   title_new_txtP_mv^101   title_new^100   series^50   series2^30   author^500   author_fuller^150   contents^10   topic_unstemmed^404   topic^400   geographic^300   genre^300   allfields_unstemmed^10   fulltext_unstemmed^10   allfields isbn issn"
      @config.phrase_fields = @config.phrase_fields || "title_txtP^100"
      @config.boost_functions = @config.boost_functions || "recip(ms(NOW,publishDateBoost_tdate),3.16e-11,1,1)^1.0";
      @config.sort = @config.sort || [ {score: :descending}, {_docid_: :descending} ]
      
    elsif @config.type == WORLDCAT
      
    end
  end
  
end