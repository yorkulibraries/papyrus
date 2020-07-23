class Search::OmniController < AuthenticatedController

  before_action do
    authorize! :search, :items
  end

  def new
  end

  def show
    @query = params[:q]
    @item_results = Item.search(@query).limit(6)
    @student_results = Student.search(@query).limit(6)
  end

end
