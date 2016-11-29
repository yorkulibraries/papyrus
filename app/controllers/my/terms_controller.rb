class My::TermsController < My::BaseController

  skip_filter :check_terms_acceptance

  def show

  end

  def update
    session[:terms_accepted] = true
    redirect_to my_items_path
  end
end
