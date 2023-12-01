# frozen_string_literal: true

require 'test_helper'

class BibSearchTest < ActionDispatch::IntegrationTest
  #    should "search SOLR for multiple items" do
  # search_string = "Caesar"
  # record = BibRecord.new
  # results = record.search_items(search_string, BibRecord::VUFIND)

  # assert results.size > 0, "At least one result"
  #    end

  #    should "search SOLR for single item" do
  # item_id = "1970385"
  # record = BibRecord.new
  # item = record.find_item(item_id, BibRecord::VUFIND)

  # assert_not_nil item
  # assert_equal item_id, item["id"]
  #    end

  should 'search WOLRDCAT for Multiple Items' do
    search_string = 'Caesar'
    record = BibRecord.new
    results = record.search_items(search_string, BibRecord::WORLDCAT)

    assert results.size.positive?, 'At least one result should happen'
  end

  should 'search WORLDCAT for single item' do
    item_id = '671660984' # Julius Caesar by Shakespear
    record = BibRecord.new
    item = record.find_item(item_id, BibRecord::WORLDCAT)

    assert_not_nil item
    assert_equal item_id, item.id
  end
end
