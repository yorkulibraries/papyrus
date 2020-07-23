class Items::FromWorldcatController < AuthenticatedController
  before_action do
    authorize! :search, :items
  end

  def index
    @query = params[:q]
    begin
      if @query.present?
        @results = search_worldcat(@query)
      end
    rescue StandardError => e
      @show_error = true
      @error = e
    end
  end

  def new
    if params[:worldcat_id].present?
      @record = BibRecord::WorldcatResult.find_item params[:worldcat_id]
      @item = BibRecord::WorldcatResult.build_item_from_worldcat_result @record, Item::BOOK
    else

      @item = Item.new
      @item.unique_id = "oclc_#{Time.now.to_i}"
      @item.title = params[:title]
      @item.author = params[:author]
      @item.isbn = params[:isbn]
      @item.publisher = params[:publisher]
      @item.published_date = params[:published_date]
      @item.edition = params[:edition]
      @item.physical_description = params[:physical_description]
    end
  end


  private
  def search_worldcat(query)

    bib_record = BibRecord.new
    @bib_search = true

    @docs = bib_record.search_items(query, BibRecord::WORLDCAT)

    return @docs
  end



end
