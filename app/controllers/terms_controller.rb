class TermsController < AuthenticatedController
  authorize_resource

  def search_courses
    @query = params[:q].strip
    @courses = Course.search(@query)
    #Course.joins(:term).where("terms.end_date >= '#{Date.today}'").where("courses.title like \"%#{@query}%\" || courses.code like \"%#{@query}%\" ")

      respond_to do |format|
        format.json { render json: @courses.map { |course| { id: course.id, name: "#{course.title}", term: "#{course.term.name}" } } }
        format.html
      end
  end


  def index
    @terms = Term.active
    @archived_terms = Term.archived.limit(10)
  end

  def show
    @terms = Term.active
    @term = Term.find(params[:id])
    @courses = @term.courses.includes(:term)
  end

  def new
    @term = Term.new
  end

  def create

    @term = Term.new(term_params)

    if @term.save
      redirect_to @term, notice: "Successfully created term."
    else
      render action: 'new'
    end
  end

  def edit
    @term = Term.find(params[:id])
  end

  def update
    @term = Term.find(params[:id])
    if @term.update_attributes(term_params)
      redirect_to @term, notice: "Successfully updated term."
    else
      render action: 'edit'
    end
  end

  def destroy
    @term = Term.find(params[:id])
    @term.destroy
    redirect_to terms_path, notice: "Successfully destroyed term."
  end

  private
  def term_params
      params.require(:term).permit( :name, :start_date, :end_date)
  end
end
