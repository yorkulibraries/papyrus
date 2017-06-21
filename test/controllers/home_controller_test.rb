require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest

  setup do
    @current_user = create(:user)
    log_user_in(@current_user)


  end

  should "display index page with assigned students and recently worked on items" do
    student = create(:student)
    details = create(:student_details, student: student, transcription_coordinator: @current_user)

    student2 = create(:student, inactive: true)
    details2 = create(:student_details, student: student2, transcription_coordinator: @current_user)

    get root_url
    assert_response :success
    assert_equal "Logged in!", flash[:notice]

  end


end
