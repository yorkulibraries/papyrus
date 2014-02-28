require 'test_helper'

class BibSearchTest < ActionDispatch::IntegrationTest


  setup do
    if ENV["WORLDCAT_KEY"] == nil 
      puts "PREREQ: ENV[WORLCAT_KEY] is set to a key"
    end
    
    PapyrusConfig.configure do |config|
      config.bib_search.solr.url = "http://iota.library.yorku.ca/solr/biblio"
      config.bib_search.worldcat.key = ENV["WORLDCAT_KEY"]
    end
  end

  
  should "search SOLR for multiple items" do
    search_string = "Caesar"
    record = BibRecord.new(PapyrusConfig.bib_search)
    results = record.search_items(search_string, BibRecord::SOLR)
    
    assert results.size > 0, "At least one result"
  end
  
  should "search SOLR for single item" do
    item_id = "1970385"
    record = BibRecord.new(PapyrusConfig.bib_search)
    item = record.find_item(item_id, BibRecord::SOLR)
    
    assert_not_nil item
    assert_equal item_id, item["id"] 
  end
  
  
  should "search WOLRDCAT for Multiple Items" do
    search_string = "Caesar"
    record = BibRecord.new(PapyrusConfig.bib_search)
    results = record.search_items(search_string, BibRecord::WORLDCAT)
    
    assert results.size > 0, "At least one result should happen"
  end
  
  should "search WORLDCAT for single item" do
    item_id = "671660984"  # Julius Caesar by Shakespear
    record = BibRecord.new(PapyrusConfig.bib_search)
    item = record.find_item(item_id, BibRecord::WORLDCAT)
    
    assert_not_nil item    
    assert_equal item_id, item[:id]
  end
  
  
end
