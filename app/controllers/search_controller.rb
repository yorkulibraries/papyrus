class SearchController < ApplicationController
  before_filter do
    authorize! :search, :items
  end

  def index
  end

  def items
    @search_results = params[:type] || "local"
    page_number = params[:page] ||= 1

    case params[:type]
    when BibRecord::WORLDCAT
      @results = search_worldcat(params[:q])
    when BibRecord::VUFIND
      @results = search_vufind(params[:q])
    else
      @results = search_local_items(params[:q])
    end


    respond_to do |format|

      if @search_results == "local"
        format.json { render json:  @results.map { |item| {id: item.id, name: "#{item.title}   <span>#{item.item_type}</span>" } } }
      else
        format.json { render json:  ActiveSupport::JSON.encode(@docs, {} ) }
      end

      format.html
    end

  end


  private
  def search_vufind(query)
    bib_record = BibRecord.new
    @bib_search = true

    @docs = bib_record.search_items(query, BibRecord::VUFIND)

    return @docs
  end

  def search_worldcat(query)

    bib_record = BibRecord.new
    @bib_search = true

    @docs = bib_record.search_items(query, BibRecord::WORLDCAT)

    return @docs
  end

  def search_local_items(query)
    page_number = params[:page] ||= 1

    query = query.strip unless query.blank?


    @items = Item.where("title like ? OR isbn like ? or unique_id = ? or author like ?",
                        "%#{query}%", "%#{query}%", "#{query}", "%#{query}%")

    unless params[:books].nil? && params[:articles].nil? && params[:course_kits].nil?
      @items = @items.where({ format: params[:books]} | {format: params[:articles]} | {format: params[:course_kits]})
    end

    @items = @items.page page_number

    return @items
  end


end
