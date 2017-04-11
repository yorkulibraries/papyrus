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

end
