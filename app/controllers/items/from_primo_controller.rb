class Items::FromPrimoController < AuthenticatedController
  before_action do
    authorize! :search, :items
  end

  def index
    @query = params[:q]
    if @query.present?
      @results = search_primo(@query)
    end

  end


  private
  def search_primo(query)
    BibRecord::PrimoResult.search query
  end
end
