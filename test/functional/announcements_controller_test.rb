require 'test_helper'

class AnnouncementsControllerTest < ActionController::TestCase

  setup do
    @manager_user = create(:user, role: User::MANAGER)
    log_user_in(@manager_user)
  end


  should "show different announcement" do
    create_list(:announcement, 2, ends_at: 2.days.ago)
    create_list(:announcement, 3, ends_at: 2.days.from_now, audience: Announcement::AUDIENCE_USER)
    create_list(:announcement, 5, ends_at: 2.days.from_now, audience: Announcement::AUDIENCE_STUDENT)

    get :index
    assert_template :index

    announcements = assigns(:announcements)
    expired_announcements = assigns(:expired_announcements)

    assert_not_nil announcements, "Shouldn't be nil"
    assert_not_nil expired_announcements, "Shouldn't be nil"

    assert_equal 8, announcements.size, "Should only be 8 current ones"
    assert_equal 2, expired_announcements.size, "Should only be 2 expired"
  end


  should "show new form for announcement" do
    get :new
    assert_template :new
  end

  should "create a new announcement" do
    assert_difference "Announcement.count", 1 do
      post :create, announcement: { message: "whaterver", audience: Announcement::AUDIENCE_STUDENT, ends_at: "2015-10-10", starts_at: "2014-10-10" }
      a = assigns(:announcement)
      assert_equal 0, a.errors.size, "There should be no errors, #{a.errors.messages}"
      assert_not_nil a.user, "User should not be nil"
      assert_equal Announcement::AUDIENCE_STUDENT, a.audience, "Student is the audience"

      assert_redirected_to announcements_path(), "Should redirect back to announcements list"
    end
  end

  should "remove an existing announcement" do
    a = create(:announcement)

    assert_difference "Announcement.count", -1 do
      post :destroy, id: a.id
      assert_redirected_to announcements_path(), "Should redirect back to announcements list"
    end
  end
end
