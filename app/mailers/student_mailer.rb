class StudentMailer < ActionMailer::Base
 
  default :from => "papyrus-las@library.yorku.ca"

   def notification_email(student, message)
     @student = student
     @url  = "http://www.library.yorku.ca/papyrus/"
     @message = message
     mail(:to => student.email, :subject => "York Libraries Transcription Services - Papyrus Notification")
   end
  
  def welcome_email(student)
    @student = student
    @url  = "http://www.library.yorku.ca/papyrus/"
    mail(:to => student.email, :subject => "Welcome to Transcription Services")
  end
  
  def items_assigned_email(student, items)
    @student = student
    @items = items
    @url  = "http://www.library.yorku.ca/papyrus/"
    items.size > 1 ? subject = "Multiple items have now been assigned to you" : subject = "#{items.first.title} has now been assigned to you"
    
    mail(:to => student.email, :subject => subject)
  end
  
end
