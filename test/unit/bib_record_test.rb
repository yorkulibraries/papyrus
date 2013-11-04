require 'test_helper'

class BibRecordTest < ActiveSupport::TestCase
  
  setup do
    @solr_config = { type: "solr", id_prefix: "solr", url: "http://iota.library.yorku.ca/solr/biblio",  query_fields: "title_short_txtP^757.5", 
                      phrase_fields: "title_txtP^100",   boost_functions: "recip(ms(NOW,publishDateBoost_tdate),3.16e-11,1,1)^1.0",  sort: [ { score: "descending" } , { _docid_: "descending" } ]}
                      
    @solr_result = { id: "1234", title: "Some Title", callnumber: "AD 23433", author: "Some Person", author2: ["author 2", "Another Person"], isbn: "123456789012",
                     publisher: "Printing Inc.", publishDate: "2002", edition: "1st edition", physical: ["343 pages"], language: ["english", "french"] }                                            
  end
  
  should "initialize bib record, with proper type" do        
    record = BibRecord.new(PapyrusConfig.bib_search)
    assert_equal BibRecord::SOLR, record.type    
  end
  
  
  should "have sensible default is config is not provided" do
    record = BibRecord.new(nil)
    
    assert_equal BibRecord::SOLR, record.type, "Type is SOLR by default"
    assert_equal "http://localhost:8080/solr/biblio", record.config[:url], "Default url is localhost"
    assert_equal "DEFAULT_SOLR", record.config[:label], "Default label is set"
    assert_equal "default_solr", record.config[:id_prefix], "Default prefix is set"
    
  end
  
  ### SOLR CONVERSION
  should "build item from proper solr result" do
    item_type = Item::BOOK
    item = BibRecord.build_item_from_solr_result(@solr_result, item_type)   
    
    assert_equal Item::BOOK, item.item_type
    assert_equal @solr_result[:title], item.title
    assert_equal @solr_config[:id_prefix] << "_" << @solr_result[:id], item.unique_id
    assert_equal @solr_result[:isbn], item.isbn

  end
  
  
  ### METHODS COMMUNICATING WITH SOLR OR WORLDCAT ARE INSIDE INTEGRATION TEST

  
  
  
  
end