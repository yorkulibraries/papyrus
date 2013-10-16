class StudentMailer < ActionMailer::Base
 
  default from: APP_CONFIG[:notifications][:from_email]

   def notification_email(student, message)
     @student = student
     @url  = APP_CONFIG[:ogranization][:papyrus_url]
     @message = message
     mail( to: student.email, subject: APP_CONFIG[:notifications][:notification_subject])
   end
  
  def welcome_email(student)
    @student = student
    @url  = APP_CONFIG[:ogranization][:papyrus_url]
    mail(to: student.email, subject: APP_CONFIG[:notifications][:welcome_subject])
  end
  
  def items_assigned_email(student, items)
    @student = student
    @items = items
    @url  = APP_CONFIG[:ogranization][:papyrus_url]
    
    mail(to: student.email, subject: APP_CONFIG[:notifications][items_assigned_subject])
  end
  
end
