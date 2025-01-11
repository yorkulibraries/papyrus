class StudentMailer < ActionMailer::Base
  default from: PapyrusSettings.email_from

  def notification_email(student, sender, message)
    @template = Liquid::Template.parse(PapyrusSettings.email_notification_body)  # Parses and compiles the template

    @student = student
    @sender = sender
    @url = PapyrusSettings.org_app_url
    @message = message

    ## extra setup variables
    @date = Date.today.strftime('%b %e, %Y')
    @date_short = Date.today.strftime('%m-%d-%Y')
    @app_name = PapyrusSettings.app_name
    @org_name = PapyrusSettings.org_name

    if PapyrusSettings.email_allow && !student.email.nil?
      mail(to: student.email, cc: sender.email, subject: PapyrusSettings.email_notification_subject)

      @student.audit_comment = "Sent Notification Email to #{@student.email}"
      @student.save
    end
  end

  def welcome_email(student, sender)
    @student = student
    @sender = sender
    @url  = PapyrusSettings.org_app_url

    ## extra setup variables
    @date = Date.today.strftime('%b %e, %Y')
    @date_short = Date.today.strftime('%m-%d-%Y')
    @app_name = PapyrusSettings.app_name
    @org_name = PapyrusSettings.org_name
    @counsellor_email = student.details.cds_counsellor_email

    #if PapyrusSettings.email_lab_access_enable && @student.lab_access_only?
    if PapyrusSettings.email_lab_access_enable.to_s.casecmp('true').zero? && @student.lab_access_only?
      @subject = PapyrusSettings.email_lab_access_subject
      @template = Liquid::Template.parse(PapyrusSettings.email_lab_access_body) # Parses and compiles the template
    else
      @subject = PapyrusSettings.email_welcome_subject
      @template = Liquid::Template.parse(PapyrusSettings.email_welcome_body) # Parses and compiles the template
    end

    if PapyrusSettings.email_allow && !student.email.nil?
      mail(to: student.email, cc: sender.email, bcc: @counsellor_email, subject: @subject)

      @student.audit_comment = "Sent to #{@student.email}"
      @student.save
    end
  end

  def items_assigned_email(student, items, sender)
    @template = Liquid::Template.parse(PapyrusSettings.email_item_assigned_body) # Parses and compiles the template

    @student = student
    @items = items.map { |i| i.title }.join("\n ")
    @url  = PapyrusSettings.org_app_url

    ## extra setup variables
    @date = Date.today.strftime('%b %e, %Y')
    @date_short = Date.today.strftime('%m-%d-%Y')
    @app_name = PapyrusSettings.app_name
    @org_name = PapyrusSettings.org_name

    if PapyrusSettings.email_allow && !student.email.nil?
      mail(to: student.email, cc: sender.email, subject: PapyrusSettings.email_item_assigned_subject)

      @student.audit_comment = "Sent Assigned Items Notice to #{@student.email}"
      @student.save
    end
  end
end
