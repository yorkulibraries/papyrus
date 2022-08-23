# frozen_string_literal: true

class Items::FromPrimoController < AuthenticatedController
  before_action do
    authorize! :search, :items
  end

  def index
    @query = params[:q]
    begin
      @results = search_primo(@query) if @query.present?
    rescue StandardError => e
      @show_error = true
      @error = e
    end
  end

  def new
    if params[:bib_record_id].present?
      @record = BibRecord::AlmaResult.find_item params[:bib_record_id]
      @item = BibRecord::AlmaResult.build_item_from_alma_result @record
    else

      @item = Item.new
      @item.unique_id = "primo_#{params[:primo_id]}"
      @item.title = params[:title]
      @item.author = params[:author]
      @item.isbn = params[:isbn_issn]
      @item.callnumber = params[:callnumber]
      @item.publisher = params[:publisher]
      @item.published_date = params[:publication_date]
      @item.edition = params[:edition]
      @item.language_note = params[:language]
      @item.physical_description = params[:description]
    end
  end

  def create; end

  private

  def search_primo(query)
    BibRecord::PrimoResult.search query
  end
end
