require 'test_helper'

class StudentMailerTest < ActionMailer::TestCase

  should "Send a welcome email" do
    PapyrusSettings.email_allow = true
    student = create(:student)
    details = create(:student_details, student: student)
    sender = create(:user)

    mail = StudentMailer.welcome_email(student, sender).deliver_now
    assert !ActionMailer::Base.deliveries.empty?, "Shouldn't be empty"

    assert_equal PapyrusSettings.email_welcome_subject, mail.subject
    assert_equal [student.email], mail.to, "TO should be student email"
    assert_equal [sender.email], mail.cc, "CC should be sender"
    assert_equal [student.details.cds_counsellor_email], mail.bcc, "BCC should be counsellor"
    assert_equal [PapyrusSettings.email_from], mail.from

  end

  should "not set email if allow email is false" do
    PapyrusSettings.email_allow = false
    student = create(:student)
    sender = create(:user)

    StudentMailer.welcome_email(student, sender).deliver_now
    assert ActionMailer::Base.deliveries.empty?, "Should be empty"

    PapyrusSettings.email_allow = true

  end

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

  should "send out items assigned email" do
    PapyrusSettings.email_allow = true

    sender = create(:user, email: "sender@sender.com")

    student = create(:student, email: "whatever@whatever.com")
    items = create_list(:item, 3)

    email = StudentMailer.items_assigned_email(student, items, sender).deliver_now

    # Test delivery
    assert !ActionMailer::Base.deliveries.empty?

    assert_equal [student.email], email.to
    assert_equal [sender.email], email.cc
    assert_equal PapyrusSettings.email_item_assigned_subject, email.subject
  end

  should "have a item title in sujbect if sending just one assigned item email" do
    PapyrusSettings.email_allow = true

    student = create(:student, email: "whatever@whatever.com")
    items = create_list(:item, 1, title: "Test")
    sender = create(:user, email: "sender@sender.com")

    email = StudentMailer.items_assigned_email(student, items, sender).deliver_now

    assert_equal PapyrusSettings.email_item_assigned_subject, email.subject
  end

end
