# frozen_string_literal: true

require 'test_helper'

module My
  class TermsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @student = create(:student)
      log_user_in(@student)
    end

    should 'show terms page' do
      get my_terms_path
      assert_response :success
    end

    should 'accept terms and redirect to items page' do
      patch my_terms_path

      assert session[:terms_accepted], 'Should be accepted terms'

      assert_redirected_to my_items_path
    end
  end
end
