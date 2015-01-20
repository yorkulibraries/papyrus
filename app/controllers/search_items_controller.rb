class SearchItemsController < ApplicationController
  before_filter do
    authorize! :search, :items
  end

  def index
    @search_results = params[:type] || "local"

    case params[:type]
    when BibRecord::WORLDCAT
      search_worldcat(params[:q])
    when BibRecord::SOLR
      search_solr(params[:q])
    else
      search_local(params[:q])
    end


  end

  private 
  def search_solr(query)
    bib_record = BibRecord.new(PapyrusConfig.bib_search)
    @bib_search = true

    @docs = bib_record.search_items(query, BibRecord::SOLR)

    respond_to do |format|
      format.json { render json: ActiveSupport::JSON.encode(@docs, {} ) }
      format.html { render template: "items/index" }
    end
  end

  def search_worldcat(query)

    bib_record = BibRecord.new(PapyrusConfig.bib_search)
    @bib_search = true

    @docs = bib_record.search_items(query, BibRecord::WORLDCAT)

    respond_to do |format|
      format.json { render json:  ActiveSupport::JSON.encode(@docs, {} ) }
      format.html { render template: "items/index" }
    end
  end

  def search_local(query)
    page_number = params[:page] ||= 1

    query = query.strip unless query.blank?


    @items = Item.where{
        { title.matches => "%#{query}%"} |
        { isbn.matches => "%#{query}%"} |
        { unique_id => "#{query}"} |
        { author.matches => "%#{query}%"}
    }


    unless params[:books].nil? && params[:articles].nil? && params[:course_kits].nil?
      @items = @items.where({:format => params[:books]} | {:format => params[:articles]} | {:format => params[:course_kits]})
    end

    @items = @items.page page_number

    respond_to do |format|
      format.json { render :json =>  @items.map { |item| {:id => item.id, :name => "#{item.title}   <span>#{item.item_type}</span>" } } }
      format.html { render :template => "items/index" }
    end
  end


end
