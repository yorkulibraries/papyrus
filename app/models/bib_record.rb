require "ostruct"

class BibRecord
  attr_reader :config_solr, :config_worldcat
  
  ## CONSTANTS
  SOLR = "solr"
  WORLDCAT = "worldcat"
  
  
  def initialize(config)
    config = OpenStruct.new if config == nil # config can't be nil
 
    @config_solr = config.solr
    @config_worldcat = config.worldcat     
        
    ensure_config_defaults
        
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
  
  def build_item_from_search_result(result, source)
    if source == SOLR
      BibRecord.build_item_from_solr_result(result, item_type, @config_solr.id_prefix)
    elsif source == WORLDCAT
      BibRecord.build_item_from_worldcat_result(result, item_type, @config_worldcat.id_prefix)
    else
      "Item Can't be built"
    end
  end
  ## SOLR SPECIFIC METHODS
  
  def search_solr_items(query)
    require 'solr'
    solr = Solr::Connection.new(@config_solr.url)
  
    query_fields = @config_solr.query_fields
    phrase_fields = @config_solr.phrase_fields
    boost_functions = @config_solr.boost_functions
    sort = @config_solr.sort
    
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
    solr = Solr::Connection.new(@config_solr.url)
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
    # Check to make sure they are not nil

    
    if @config_solr == nil
      @config_solr = OpenStruct.new(PapyrusConfig::DEFAULT_SOLR_CONFIG)
    end
    
    if @config_worldcat == nil
      @config_worldcat = OpenStruct.new(PapyrusConfig::DEFAULT_WORLDCAT_CONFIG)
    end
    
    
    #Check SOLR
    @config_solr.label = @config_solr.label || PapyrusConfig::DEFAULT_SOLR_CONFIG[:label]
    @config_solr.id_prefix = @config_solr.id_prefix || PapyrusConfig::DEFAULT_SOLR_CONFIG[:id_prefix]
    @config_solr.url = @config_solr.url || PapyrusConfig::DEFAULT_SOLR_CONFIG[:url]
    @config_solr.query_fields = @config_solr.query_fields || PapyrusConfig::DEFAULT_SOLR_CONFIG[:query_fields]
    @config_solr.phrase_fields = @config_solr.phrase_fields || PapyrusConfig::DEFAULT_SOLR_CONFIG[:phrase_fields]
    @config_solr.boost_functions = @config_solr.boost_functions || PapyrusConfig::DEFAULT_SOLR_CONFIG[:boost_functions]
    @config_solr.sort = @config_solr.sort || PapyrusConfig::DEFAULT_SOLR_CONFIG[:sort]
      
    # Check WORLDCAT
    @config_worldcat.id_prefix = @config_worldcat.id_prefix || PapyrusConfig::DEFAULT_WORLDCAT_CONFIG[:id_prefix]
    
  end
  
end
