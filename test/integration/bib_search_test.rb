require 'test_helper'

class BibSearchTest < ActionDispatch::IntegrationTest

  if ENV["WORLDCAT_KEY"] == nil || ENV["SOLR_PATH"] == nil
    puts "To run integration test for Bib Search set the two params"
    puts  "PREREQ: ENV[WORLDCAT_KEY] is set to a key"
    puts "PREREQ: ENV[SOLR_PATH] is set to a path for solr"
  else
    setup do
      PapyrusConfig.configure do |config|
        config.bib_search.solr.url = ENV["SOLR_PATH"]
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
      assert_equal item_id, item.id
    end



  end


end
