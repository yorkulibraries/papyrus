# frozen_string_literal: true

require 'test_helper'

module My
  class AccessCodesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @student = create(:student)
      log_user_in(@student)
    end

    should 'show access codes page' do
      patch my_terms_path
      get my_access_codes_path

      assert_response :success
      assert assigns(:student)
    end

    should 'redirect to terms page if terms not accepted' do
      get my_access_codes_path

      assert_redirected_to my_terms_path
    end
  end
end
