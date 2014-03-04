require 'test_helper'

class SearchItemsControllerTest < ActionController::TestCase

  setup do
    @user = create(:user)
    log_user_in(@user)
     PapyrusConfig.reset_defaults
  end
  
  should "search items database if no type was specified" do
    create(:item, title: "unique title")
    create(:item, isbn: "9-233-12345")
    create(:item, unique_id: "000111")
    create(:item, author: "john smith") 
    
    
    get :index, q: "unique"
    search_results = assigns(:search_results)    
    assert_equal "local", search_results, "search results should be set to local"
    assert_response :success
    assert_template :index

    items = assigns(:items)
    assert_equal "unique title", items.first.title

    get :index, q: "9-233"
    items = assigns(:items)
    assert_equal "9-233-12345", items.first.isbn

    get :index, q: "000111"
    items = assigns(:items)
    assert_equal "000111", items.first.unique_id

    get :index, q: "john"
    items = assigns(:items)    
    assert_equal "john smith", items.first.author
    
  end
  
  should "search solr if solr is selected" do
    ## if this test fails, first check if there is a test solr config
    PapyrusConfig.config.bib_search.solr.url = "http://iota.library.yorku.ca/solr/biblio"
    
    get :index, type: BibRecord::SOLR, q: "caesar"
    search_results = assigns(:search_results)    
    assert_equal "solr", search_results, "search results should be set to solr"
    assert_response :success
    assert_template :index

    docs = assigns(:docs)
    assert docs, "Docs ain't nil"
    assert docs.size > 0, "At least one result"
  end
  
  
  should "search worldcat if worldcat search type is selected" do
    ## if this test fails, ensure the worldcat key is provided
    PapyrusConfig.config.bib_search.worldcat.key = ENV["WORLDCAT_KEY"]
    
    get :index, type: BibRecord::WORLDCAT, q: "caesar"
    search_results = assigns(:search_results)
    assert_equal BibRecord::WORLDCAT, search_results, "search results should be set to worldcat"
    assert_response :success
    assert_template :index
    assert_template :worldcat_results
    
    docs = assigns(:docs)
    assert docs, "Doc ain't nil"
    assert docs.size > 0, "At least one result"
  end

end
