class ReportMailer < ActionMailer::Base

  default from: PapyrusConfig.notifications.from_email

  def mail_report(who, report, mail_subject)
    mail(to: who, subject: mail_subject, body: report)      
  end

end
