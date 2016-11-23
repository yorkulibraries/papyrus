require 'test_helper'

class UserTest < ActiveSupport::TestCase

  should "list inactive and active users" do
    create_list(:user, 3, inactive: true)
    create_list(:user, 4, inactive: false)

    assert_equal 3, User.inactive.count, "Should be 3"
    assert_equal 4, User.active.count, "Should be 4"
  end


  should "list non student users" do
    create_list(:user, 2, role: User::STUDENT_USER)
    create_list(:user, 3, role: User::ADMIN)

    assert_equal 3, User.not_students.count, "3 Non students"
    assert_equal 5, User.count, "All together 5 user accounts"
  end

  should "List transcription assistants" do
    create_list(:user, 2, role: User::MANAGER)
    create_list(:user, 2, role: User::PART_TIME)
    create_list(:user, 2, role: User::COORDINATOR)
    create_list(:user, 2, role: User::STUDENT_USER)
    create_list(:user, 2, role: User::ADMIN)


    assert_equal 6, User.transcription_assitants.count, "8 Transcription assistants, ADMINS are now included"
  end


  should "default to ordering by user's name" do
    create(:user, last_name: "Zach")
    create(:user, last_name: "Andrew")
    create(:user, last_name: "John")


    assert_equal "Andrew", User.ordered_by_last_name.first.last_name, "Andrew is first"
    assert_equal "Zach", User.ordered_by_last_name.last.last_name, "Zach is first"
  end

  should "create a valid user" do
    user = build(:user)

    assert_difference "User.count", 1 do
      user.save
    end
  end

  should "not create an invalid user" do
    assert ! build(:user, email: nil).valid?, "Email can't be nil"
    assert ! build(:user, email: "test").valid?, "Email must be valid"
    assert ! build(:user, first_name: nil).valid?, "First Name is required"
    assert ! build(:user, last_name: nil).valid?, "Last Name is required"
    assert ! build(:user, username: nil).valid?, "Username is required"
    assert ! build(:user, username: "#1299").valid?, "Username must be valid"
    assert ! build(:user, role: nil).valid?, "Role is required"
    #assert ! build(:user, role: "some role of sorts"), "Role must be one of defined roles"

    user = build(:user, email: "test", first_name: nil, username: "12#whatever")
    assert_no_difference "User.count" do
      user.save
    end
  end

  should "not create user if username or email is already in database" do
    create(:user, username: "tester", email:"tester@test.com")

    assert ! build(:user, email: "tester@test.com").valid?, "Email is in use"
    assert ! build(:user, username: "tester").valid?, "Username is in use"
  end



  should "update an existing user" do
    u = create(:user, username: "old", email: "test@test.com")

    u.username = "new"
    u.email = "new@test.com"
    u.save
    u.reload

    assert_equal "new", u.username, "Username changed"
    assert_equal "new@test.com", u.email, "Email changed"

  end

  should "destroy an existing user" do
    u = create(:user)

    assert_difference "User.count", -1 do
      u.destroy
    end
  end


  should "record activity time, based on action" do
    u = create(:user)
    u.active_now!
    u.reload
    assert Time.now >= u.last_active_at, "Should record last active time"

    u.active_now!(User::ACTIVITY_LOGIN)
    u.reload
    assert Time.now >= u.last_logged_in_at, "Should record last logged in time"
  end

end
