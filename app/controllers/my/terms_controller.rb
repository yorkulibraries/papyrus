# frozen_string_literal: true

class My::TermsController < My::BaseController
  skip_before_action :check_terms_acceptance

  def show; end

  def update
    session[:terms_accepted] = true
    redirect_to my_items_path
  end
end
