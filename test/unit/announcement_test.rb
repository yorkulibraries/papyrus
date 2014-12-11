require 'test_helper'

class AnnouncementTest < ActiveSupport::TestCase

  should "create a valid announcement" do
    a = build(:announcement)

    assert_difference "Announcement.count", 1 do
      a.save
    end
  end

  should "not create an invalid announcement" do

    assert ! build(:announcement, message: nil).valid?, "Message is required"
    assert ! build(:announcement, ends_at: nil).valid?, "Ends At is required"
    assert ! build(:announcement, starts_at: nil).valid?, "Starts At is required"
    assert ! build(:announcement, audience: nil).valid?, "Audience is required"
    assert ! build(:announcement, user: nil).valid?, "User is required"
  end

  should "get current only messages" do
    expired = create(:announcement, ends_at: 4.years.ago, starts_at: 10.years.ago)
    current = create(:announcement)

    assert_equal 1, Announcement.current.size, "Should only be one"
  end

  should "get current by audience" do
    expired = create(:announcement, ends_at: 4.years.ago, starts_at: 10.years.ago)
    create(:announcement, audience: Announcement::AUDIENCE_STUDENT)
    create(:announcement, audience: Announcement::AUDIENCE_USER)

    assert_equal 2, Announcement.current.size, "Two Together"

    assert_equal 1, Announcement.current(nil, Announcement::AUDIENCE_STUDENT).size, "Should only be one, student annoucement"
    assert_equal 1, Announcement.current(nil, Announcement::AUDIENCE_USER).size, "Should only be one user annoucement"

  end

  should "exclude certain ids" do
    s = create(:announcement, audience: Announcement::AUDIENCE_STUDENT)
    u = create(:announcement, audience: Announcement::AUDIENCE_USER)

    assert_equal 1, Announcement.current("#{s.id}").size, "Should only be one"
    assert_equal u.id, Announcement.current("#{s.id}").first.id, "Should be user's announcement"
  end

  should "show expired annoucemments" do
    expired = create(:announcement, ends_at: 4.years.ago, starts_at: 10.years.ago)
    current = create(:announcement)

    assert_equal 1, Announcement.expired.size, "Should only be one"
  end



end
