class TermsController < ApplicationController
  authorize_resource
  
  def search_courses  
    @query = params[:q].strip
    @courses = Course.search(@query)
    #Course.joins(:term).where("terms.end_date >= '#{Date.today}'").where("courses.title like \"%#{@query}%\" || courses.code like \"%#{@query}%\" ")

      respond_to do |format|
        format.json { render json: @courses.map { |course| { id: course.id, name: "#{course.title}  <br/> <span class='weak'>#{course.term.name}</span>" } } }        
        format.html
      end                        
  end
  
  
  def index
    @terms = Term.active
    @archived_terms = Term.archived.limit(10)
  end

  def show
    @term = Term.find(params[:id])
  end

  def new
    @term = Term.new
  end

  def create
    
    @term = Term.new(params[:term])
    
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
    if @term.update_attributes(params[:term])
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
end
