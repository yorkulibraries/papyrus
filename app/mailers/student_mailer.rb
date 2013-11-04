class StudentMailer < ActionMailer::Base
 
  default from: PapyrusConfig.notifications.from_email

   def notification_email(student, message)
     @student = student
     @url  = PapyrusConfig.organization.app_url
     @message = message
     mail( to: student.email, subject: PapyrusConfig.notifications.notification_subject)
   end
  
  def welcome_email(student)
    @student = student
    @url  = PapyrusConfig.organization.app_url
    mail(to: student.email, subject: PapyrusConfig.notifications.welcome_subject)
  end
  
  def items_assigned_email(student, items)
    @student = student
    @items = items
    @url  = PapyrusConfig.organization.app_url
    
    mail(to: student.email, subject: PapyrusConfig.notifications.items_assigned_subject)
  end
  
end
