require 'test_helper'

class BibRecordTest < ActiveSupport::TestCase
  
  setup do  
    PapyrusConfig.reset_defaults                    
    
    @solr_result = { id: "1234", title: "Some Title", callnumber: "AD 23433", author: "Some Person", author2: ["author 2", "Another Person"], isbn: "123456789012",
                     publisher: "Printing Inc.", publishDate: "2002", edition: "1st edition", physical: ["343 pages"], language: ["english", "french"] }   
                     
    @worldcat_result = OpenStruct.new id: "671660984", title: "Julius Caesar", author: ["Shakespeare, William,"], 
                        summary: "Title from PDF title page (viewed Oct. 25, 2010).", link: "http://www.worldcat.org/oclc/671660984", 
                        isbn: "9781775413158 (electronic bk.)", publisher: "[Waiheke Island] :Floating Press,c2008.", physical_description: "1 online resource (182 p.)"                                                                                        
  end
  
  should "initialize bib record, with proper type" do        
    record = BibRecord.new(PapyrusConfig.bib_search)   
    assert_not_nil record.config_solr, "Solr config set up"
    assert_not_nil record.config_worldcat, "Worldcat config setup"
  end
  
  
  should "have sensible default if config is not provided SOLR AND WORLDCAT" do
    record = BibRecord.new(nil)
    
    assert_equal "http://localhost:8080/solr/biblio", record.config_solr.url, "Default url is localhost"
    assert_equal PapyrusConfig::DEFAULT_SOLR_CONFIG[:label], record.config_solr.label, "Default label is set"
    assert_equal PapyrusConfig::DEFAULT_SOLR_CONFIG[:id_prefix], record.config_solr.id_prefix, "Default prefix is set"
    
    
    assert_equal PapyrusConfig::DEFAULT_WORLDCAT_CONFIG[:id_prefix], record.config_worldcat.id_prefix, "Default prefix for worldcat"
    assert_equal PapyrusConfig::DEFAULT_WORLDCAT_CONFIG[:label], record.config_worldcat.label, "Default label for worldcat"    
  end
  
  ### SOLR CONVERSION
  should "build item from proper solr result" do
    item_type = Item::BOOK
    item = BibRecord.build_item_from_solr_result(@solr_result, item_type, PapyrusConfig.bib_search.solr.id_prefix)   
    
    assert_equal Item::BOOK, item.item_type
    assert_equal @solr_result[:title], item.title
    assert_equal "#{PapyrusConfig.bib_search.solr.id_prefix}_#{@solr_result[:id]}", item.unique_id
    assert_equal @solr_result[:isbn], item.isbn

  end
  
  
  # WORLDCAT CONVERSION
  should "build item from Proper WORLDCAT record" do
    item_type = Item::BOOK
    item = BibRecord.build_item_from_worldcat_result(@worldcat_result, item_type, PapyrusConfig.bib_search.worldcat.id_prefix)
    
    assert_equal Item::BOOK, item.item_type
    assert_equal @worldcat_result.title, item.title
    assert_equal "#{PapyrusConfig.bib_search.worldcat.id_prefix}_#{@worldcat_result.id}", item.unique_id
    assert_equal @worldcat_result.isbn, item.isbn
    
  end
  
  ### METHODS COMMUNICATING WITH SOLR OR WORLDCAT ARE INSIDE INTEGRATION TEST

  
  
  
  
end