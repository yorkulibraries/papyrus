# frozen_string_literal: true

require 'test_helper'

module My
  class DetailsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @student = create(:student)
      log_user_in(@student)
      patch my_terms_path
    end

    should 'show student details page' do
      get my_details_path

      assert_response :success
      assert assigns(:student_details)
    end

    should 'assign review_details variable if review parameter is present' do
      get my_details_path, params: { welcome: true }

      welcome_details = assigns(:welcome_details)
      assert welcome_details == true, "Should be assigned, because we're new"
    end
  end
end
