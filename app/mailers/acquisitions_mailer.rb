class AcquisitionsMailer < ActionMailer::Base
  default from: PapyrusSettings.email_from

  add_template_helper(ItemsHelper)

  def send_acquisition_request(acquisition_request, current_user, bookstore = false)
    @template = Liquid::Template.parse(PapyrusSettings.email_acquisitions_body)

    @acquisition_request = acquisition_request
    @item = acquisition_request.item
    @courses = @item.courses.joins(:term).where("terms.end_date >= ?", Date.today)
    @user = current_user

    if bookstore
      email = PapyrusSettings.email_acquisitions_to_bookstore
    else
      email = PapyrusSettings.email_acquisitions_to
    end

    #if PapyrusSettings.email_allow && ! email.blank?
      mail to: email, cc: current_user.email, subject: PapyrusSettings.email_acquisitions_subject
    #end
  end

  def test
    mail to: "whoot@wooot.com", subject: "WOOT THERE IS", body: "whehreoodfhoasdhfoas"
  end

end
