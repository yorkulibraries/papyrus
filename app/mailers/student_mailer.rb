class StudentMailer < ActionMailer::Base

  default from: PapyrusSettings.email_from

   def notification_email(student, sender, message)
     @student = student
     @sender = sender
     @url  = PapyrusSettings.org_app_url
     @message = message
     mail( to: student.email, cc: sender.email, subject: PapyrusSettings.email_notification_subject)
   end

  def welcome_email(student, sender)
    @student = student
    @sender = sender
    sender_email = sender.email
    @url  = PapyrusSettings.org_app_url
    mail(to: student.email, cc: sender_email, subject: PapyrusSettings.email_welcome_subject)
  end

  def items_assigned_email(student, items)
    @student = student
    @items = items
    @url  = PapyrusSettings.org_app_url

    mail(to: student.email, subject: PapyrusSettings.notifications.email_item_assigned_subject)
  end

end
