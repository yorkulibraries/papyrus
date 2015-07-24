class ReportMailer < ActionMailer::Base

  default from: PapyrusSettings.email_from

  def mail_report(who, report, mail_subject)
    mail(to: who, subject: mail_subject, body: report)
  end

end
