require 'test_helper'

class BibSearchTest < ActionDispatch::IntegrationTest


  setup do
    @solr_config = { type: "solr", url: "http://iota.library.yorku.ca/solr/biblio",  
      query_fields: "title_short_txtP^757.5   title_short^750  title_full_unstemmed^404   title_full^400   title_txtP^750   title^500   title_alt_txtP_mv^202   title_alt^200   title_new_txtP_mv^101   title_new^100   series^50   series2^30   author^500   author_fuller^150   contents^10   topic_unstemmed^404   topic^400   geographic^300   genre^300   allfields_unstemmed^10   fulltext_unstemmed^10   allfields isbn issn", 
      phrase_fields: "title_txtP^100",   boost_functions: "recip(ms(NOW,publishDateBoost_tdate),3.16e-11,1,1)^1.0",  sort: [ { score: "descending" } , { _docid_: "descending" } ]}
  end

  
  should "search for multiple items" do
    search_string = "Caesar"
    record = BibRecord.new(@solr_config)
    results = record.search_items(search_string)
    
    assert results.size > 0, "At least one result"
  end
  
  should "search for single item" do
    item_id = "1970385"
    record = BibRecord.new(@solr_config)
    item = record.find_item(item_id)
    
    assert_not_nil item
    assert_equal item_id, item["id"]
  end
end
