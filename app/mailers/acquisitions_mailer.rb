class AcquisitionsMailer < ActionMailer::Base
  add_template_helper(ItemsHelper)

  def send_acquisition_request(acquisition_request, user, bookstore = false)
    @template = Liquid::Template.parse(PapyrusSettings.email_acquisitions_body)

    @acquisition_request = acquisition_request
    @item = acquisition_request.item
    @user = user

    if bookstore
      email = PapyrusSettings.email_acquisitions_to_bookstore
    else
      email = PapyrusSettings.email_acquisitions_to
    end

    #if PapyrusSettings.email_allow && ! email.blank?
      #mail to: email, subject: PapyrusSettings.email_acquisitions_subject
    #end
    mail(to: email, subject: "Test")
  end

end
