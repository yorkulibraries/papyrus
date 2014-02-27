require 'test_helper'

class BibSearchTest < ActionDispatch::IntegrationTest


  setup do
    PapyrusConfig.configure do |config|
      config.bib_search.solr.url = "http://iota.library.yorku.ca/solr/biblio"
    end
  end

  
  should "search for multiple items" do
    search_string = "Caesar"
    record = BibRecord.new(PapyrusConfig.bib_search)
    results = record.search_items(search_string)
    
    assert results.size > 0, "At least one result"
  end
  
  should "search for single item" do
    item_id = "1970385"
    record = BibRecord.new(PapyrusConfig.bib_search)
    item = record.find_item(item_id)
    
    assert_not_nil item
    assert_equal item_id, item["id"]
  end
end
