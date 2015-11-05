require 'test_helper'

class StudentMailerTest < ActionMailer::TestCase


  should "send out a notification email" do
    PapyrusSettings.email_allow = true

    student = create(:student, email: "whatever@whatever.com")
    message = "Some Unique Student Message"
    sender = create(:user, email: "sender@sender.com")

    email = StudentMailer.notification_email(student, sender, message).deliver_now

    # Test delivery
    assert !ActionMailer::Base.deliveries.empty?

    # Test the body of the sent email contains what we expect it to
    assert_equal [student.email], email.to
    assert_equal [sender.email], email.cc
    assert_equal PapyrusSettings.email_notification_subject, email.subject
  end

  should "send out welcome email" do
    PapyrusSettings.email_allow = true

    student = create(:student, email: "whatever@whatever.com")
    sender = create(:user, email: "nothing@matters.com")

    email = StudentMailer.welcome_email(student, sender).deliver_now

    # Test delivery
    assert !ActionMailer::Base.deliveries.empty?

    assert_equal [sender.email], email.cc
    assert_equal [student.email], email.to
    assert_equal PapyrusSettings.email_welcome_subject, email.subject
  end

  should "send out items assigned email" do
    PapyrusSettings.email_allow = true

    student = create(:student, email: "whatever@whatever.com")
    items = create_list(:item, 3)

    email = StudentMailer.items_assigned_email(student, items).deliver_now

    # Test delivery
    assert !ActionMailer::Base.deliveries.empty?

    assert_equal [student.email], email.to
    assert_equal PapyrusSettings.email_item_assigned_subject, email.subject
  end

  should "have a item title in sujbect if sending just one assigned item email" do
    PapyrusSettings.email_allow = true

    student = create(:student, email: "whatever@whatever.com")
    items = create_list(:item, 1, title: "Test")

    email = StudentMailer.items_assigned_email(student, items).deliver_now

    assert_equal PapyrusSettings.email_item_assigned_subject, email.subject
  end
end
