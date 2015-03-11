class StudentMailer < ActionMailer::Base

  default from: PapyrusConfig.notifications.from_email

   def notification_email(student, sender, message)
     @student = student
     @sender = sender
     @url  = PapyrusConfig.organization.app_url
     @message = message
     mail( to: student.email, cc: sender.email, subject: PapyrusConfig.notifications.notification_subject)
   end

  def welcome_email(student, sender)
    @student = student
    @sender = sender
    sender_email = sender.email
    @url  = PapyrusConfig.organization.app_url
    mail(to: student.email, cc: sender_email, subject: PapyrusConfig.notifications.welcome_subject)
  end

  def items_assigned_email(student, items)
    @student = student
    @items = items
    @url  = PapyrusConfig.organization.app_url

    mail(to: student.email, subject: PapyrusConfig.notifications.items_assigned_subject)
  end

end
