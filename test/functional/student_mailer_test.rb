require 'test_helper'

class StudentMailerTest < ActionMailer::TestCase
  
  
  should "send out a notification email" do
    student = create(:student, email: "whatever@whatever.com")
    message = "Some Unique Student Message"
    
    email = StudentMailer.notification_email(student, message).deliver
    
    # Test delivery
    assert !ActionMailer::Base.deliveries.empty?

    # Test the body of the sent email contains what we expect it to
    assert_equal [student.email], email.to
    assert_equal "Your Institution/Department Name Transcription Services - Papyrus Notification", email.subject
    assert_match(/Some Unique Student Message/, email.encoded)
        
  end
  
  should "send out welcome email" do
    student = create(:student, email: "whatever@whatever.com")
      

    email = StudentMailer.welcome_email(student).deliver

    # Test delivery
    assert !ActionMailer::Base.deliveries.empty?

    assert_equal [student.email], email.to
    assert_equal "Welcome to Transcription Services", email.subject
  end
  
  should "send out items assigned email" do
    student = create(:student, email: "whatever@whatever.com")
    items = create_list(:item, 3)
    
    email = StudentMailer.items_assigned_email(student, items).deliver

    # Test delivery
    assert !ActionMailer::Base.deliveries.empty?

    assert_equal [student.email], email.to
    assert_equal "Multiple items have now been assigned to you", email.subject    
  end
  
  should "have a item title in sujbect if sending just one assigned item email" do
    student = create(:student, email: "whatever@whatever.com")
    items = create_list(:item, 1, title: "Test")
    
    email = StudentMailer.items_assigned_email(student, items).deliver
    
    assert_equal "Multiple items have now been assigned to you", email.subject
  end
end
