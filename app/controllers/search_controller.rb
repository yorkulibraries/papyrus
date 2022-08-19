class SearchController < AuthenticatedController
  before_action do
    authorize! :search, :items
  end

  def index; end

  def students
    page_number = params[:page] ||= 1
    query = params[:q].strip
    inactive_status = params[:inactive].blank? ? false : true
    @searching = true
    @query = query

    @students = Student.joins(:student_details)
                       .where('users.first_name like ? or users.last_name like ? or users.username = ? or users.email like ? or student_details.student_number = ?',
                              "%#{query}%", "%#{query}%", "#{query}", "%#{query}%", "#{query}")

    @students = if params[:search_all]
                  @students.page page_number
                else
                  @students.where(inactive: inactive_status).page page_number
                end

    @current_items_counts = Student.item_counts(@students.collect { |s| s.id }, 'current')

    respond_to do |format|
      format.json do
        render json: @students.map { |student|
                       { id: student.id, name: "#{student.name} - #{student.details.student_number}" }
                     }
      end
      format.html { render template: 'students/index' }
    end
  end

  def items
    @search_results = params[:type] || 'local'
    @page_number = params[:page] ||= 1

    @results = case params[:type]
               when BibRecord::WORLDCAT
                 search_worldcat(params[:q])
               when BibRecord::VUFIND
                 search_vufind(params[:q])
               when BibRecord::PRIMO
                 search_primo(params[:q])
               else
                 search_local_items(params[:q])
               end

    respond_to do |format|
      if @search_results == 'local'
        format.json do
          render json: @results.map { |item|
                         {
                           id: item.id, name: item.title, course_code: item.course_code, item_type: item.item_type,
                           edition: item.edition, author: item.author, isbn: item.isbn, callnumber: item.callnumber
                         }
                       }
        end
      else
        format.json { render json: ActiveSupport::JSON.encode(@docs, {}) }
      end

      format.html
    end
  end

  private

  def search_primo(query)
    bib_record = BibRecord.new
    @bib_search = true
    @docs = bib_record.search_items(query, BibRecord::PRIMO)
  end

  def search_vufind(query)
    bib_record = BibRecord.new
    @bib_search = true

    @docs = bib_record.search_items(query, BibRecord::VUFIND)

    @docs
  end

  def search_worldcat(query)
    bib_record = BibRecord.new
    @bib_search = true

    @docs = bib_record.search_items(query, BibRecord::WORLDCAT)

    @docs
  end

  def search_local_items(query)
    page_number = params[:page] ||= 1

    query = query.strip unless query.blank?

    @items = Item.where('title like ? OR isbn like ? or unique_id = ? or author like ?',
                        "%#{query}%", "%#{query}%", "#{query}", "%#{query}%")

    unless params[:books].nil? && params[:articles].nil? && params[:course_kits].nil?
      @items = @items.where({ format: params[:books] } | { format: params[:articles] } | { format: params[:course_kits] })
    end

    @items = @items.page page_number

    @items
  end
end
