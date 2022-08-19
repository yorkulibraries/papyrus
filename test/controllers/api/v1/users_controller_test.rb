require 'test_helper'

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    ## ENABLE API WITH HTTP_AUTH
    PapyrusSettings.api_enable = PapyrusSettings::TRUE
    PapyrusSettings.api_http_auth_enable = PapyrusSettings::FALSE
  end

  should 'return a list of students, as text and json' do
    create_list(:student, 3)
    create(:user)

    get api_v1_users_path(format: :json), params: { which: 'students' }
    json_users = JSON.parse(@response.body)
    assert_equal 3, json_users.length, 'SHould return 3 students'

    get api_v1_users_path(format: :text), params: { which: 'students' }
    text_users = @response.body
    assert_equal 3, text_users.lines.count
  end

  should 'return list of admin users, as text and json' do
    users = create_list(:user, 3)
    @creator = users.first
    details = create(:student_details, transcription_coordinator: @creator, transcription_assistant: @creator)
    create(:student, created_by: @creator, student_details: details)

    get api_v1_users_path(format: :json), params: { which: 'admins', format: :json }
    json_users = JSON.parse(@response.body)
    assert_equal 3, json_users.length, 'SHould return 3 admins as json'

    get api_v1_users_path(format: :text), params: { which: 'admins' }
    text_users = @response.body
    assert_equal 3, text_users.lines.count, 'Should return 3 admins as text'
  end

  should 'return list of both users and admins' do
    users = create_list(:user, 3)
    @creator = users.first
    details = create(:student_details, transcription_coordinator: @creator, transcription_assistant: @creator)
    create(:student, created_by: @creator, student_details: details)

    get api_v1_users_path(format: :json), params: { which: 'all' }
    json_users = JSON.parse(@response.body)
    assert_equal 4, json_users.length, 'SHould return 4 users as json'
  end

  should 'be able to specify which fields to return' do
    user = create(:user)
    get api_v1_users_path(format: :json), params: { which: 'admins', fields: 'id,first_name' }
    json_users = JSON.parse(@response.body)
    assert_equal json_users.first[0], user.id
    assert_equal json_users.first[1], user.first_name
  end

  should 'return a student if a number is passed in the which paramter' do
    student = create(:student)

    get api_v1_users_path(format: :json), params: { fields: 'id, first_name', which: student.details.student_number }
    json_users = JSON.parse(@response.body)

    assert_equal json_users.first[0], student.id
    assert_equal json_users.first[1], student.first_name
  end
end
