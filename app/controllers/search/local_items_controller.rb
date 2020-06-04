class Search::LocalItemsController < AuthenticatedController

  before_action do
    authorize! :search, :items
  end


  def index
    redirect_to new_find_item_path
  end

  def new
  end

  def create
    page_number = params[:page] ||= 1

    @query = params[:q]
    @item_type = params[:item_type]
    @source = params[:source]

    @results = Item.search(@query)

    @results = @results.where(item_type: @item_type) unless @item_type.blank?
    @results = @results.where(source: @source) unless @source.blank?

    @results = @results.page page_number

    render action: "new"
  end
end
