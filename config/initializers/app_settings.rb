
################################ IMPORTANT ###############################
## THIS IS FILE WILL SET DEFAULT PapyrusSettings IF THEY HAVE NOT BEEN SET YET.
## THIS IS NOT GOING TO CHANGE THE DATABASE VALUES IF THEY HAVE BEEN SET
## TO CHANGE THESE PapyrusSettings, go to the PapyrusSettings path and change it there.
##########################################################################

## A hack to make sure assets precompile or migrate runs properly
if ActiveRecord::Base.connection.table_exists? 'settings'

  ## Name and Owner
  PapyrusSettings.save_default(:app_name, "Papyrus")
  PapyrusSettings.save_default(:app_owner, "York University Libraries")

  ## MINI PROFILER
  PapyrusSettings.save_default(:profiler_enable, PapyrusSettings::FALSE)

  ## Organization
  PapyrusSettings.save_default(:org_name, "Your Institutioin/Department")
  PapyrusSettings.save_default(:org_short_name, "SHORT_NAME")
  PapyrusSettings.save_default(:org_app_url, "http://your-institution.website/papyrus/")

  ## Courses
  PapyrusSettings.save_default(:course_code_sample, "2011_AP_ADMS_F_1000__3_A")
  PapyrusSettings.save_default(:course_lookup_url, "http:://your-institution.website/coursecode-lookup")
  PapyrusSettings.save_default(:course_sync_on_login, true)
  PapyrusSettings.save_default(:course_listing_header, "COURSE_LIST_HEADER")
  PapyrusSettings.save_default(:course_listing_separator, ",")

  PapyrusSettings.save_default(:term_fall_start, "Sep 1")
  PapyrusSettings.save_default(:term_fall_end, "Dec 31")
  PapyrusSettings.save_default(:term_winter_start, "Jan 1")
  PapyrusSettings.save_default(:term_winter_end, "April 30")
  PapyrusSettings.save_default(:term_year_start, "Sep 1")
  PapyrusSettings.save_default(:term_year_end, "April 30")
  PapyrusSettings.save_default(:term_summer_start, "May 1")
  PapyrusSettings.save_default(:term_summer_end, "Aug 31")


  ## Items
  PapyrusSettings.save_default(:item_sources, ["Publisher", "AERO", "Student Purchase"])

  ## Autehntication
  PapyrusSettings.save_default(:auth_cas_header, "REMOTE_USER")
  PapyrusSettings.save_default(:auth_cas_header_alt, "REMOTE_USER_ID")
  PapyrusSettings.save_default(:auth_cas_user_id_label, "Authentication Username")
  PapyrusSettings.save_default(:auth_cas_logout_redirect, "http://www.your-instituttion.website")
  PapyrusSettings.save_default(:auth_cookies_domain, "your-domain.com")

  ## Error Handling
  PapyrusSettings.save_default(:errors_email_subject_prefix, "[Papyrus Error] ")
  PapyrusSettings.save_default(:errors_email_from, "'Papyrus Notifier' <papyrus-errors@your-instituttion.website>")
  PapyrusSettings.save_default(:errors_email_to, ["your.email@your-instituttion.email"])

  ## Notifications & Email

  PapyrusSettings.save_default(:email_allow, true)
  PapyrusSettings.save_default(:email_from,  "papyrus@your-insitution.email")
  PapyrusSettings.save_default(:email_welcome_subject,  "Subject of welcome email")
  PapyrusSettings.save_default(:email_welcome_body,  "Welcome email text goes here")
  PapyrusSettings.save_default(:email_notification_subject,  "Subject of Notification email")
  PapyrusSettings.save_default(:email_notification_body,  "Notification email text goes here")
  PapyrusSettings.save_default(:email_item_assigned_subject,  "Subject for Item Assigned email")
  PapyrusSettings.save_default(:email_item_assigned_body,  "Item Assigned email text goes here")

  ## Acquisitions Email
  PapyrusSettings.save_default(:email_acquisitions_to, "acquisitions_mailer@test.yorku.ca")
  PapyrusSettings.save_default(:email_acquisitions_to_bookstore, "bookstore@test.yorku.ca")
  PapyrusSettings.save_default(:email_acquisitions_subject, "Please Acquire This Item")
  PapyrusSettings.save_default(:email_acquisitions_body, "This is the stuff to be emailed")


  ## Acquisition Sources Settings
  PapyrusSettings.save_default(:acquisition_sources, ["Publisher", "Requester", "Library Loan", "Other"])
  PapyrusSettings.save_default(:acquisition_reasons, ["New Copy Required", "Missing Item", "Other"])



  ## VuFIND
  PapyrusSettings.save_default(:vufind_url, "https://www.library.yorku.ca/find/Search/Results")
  PapyrusSettings.save_default(:vufind_label, "Your Catalogue")
  PapyrusSettings.save_default(:vufind_id_prefix, "vufind")

  ## WORLDCAT
  PapyrusSettings.save_default(:worldcat_key, "enter-your-key-here")
  PapyrusSettings.save_default(:worldcat_label, "Worldcat Serach")
  PapyrusSettings.save_default(:worldcat_id_prefix, "oclc")

  ## Reporting
  PapyrusSettings.save_default(:reports_default_interval, 30.days)
  PapyrusSettings.save_default(:reports_fiscal_year_start, "May 1")

  ## Import Settings
  PapyrusSettings.save_default(:import_auto_assign_coordinator, PapyrusSettings::FALSE)
  PapyrusSettings.save_default(:import_send_welcome_email_to_student, PapyrusSettings::FALSE)
  PapyrusSettings.save_default(:import_notify_coordinator, PapyrusSettings::FALSE)

end

# Exception Notification For Production
if Rails.env.production?

  Rails.application.config.middleware.use ExceptionNotification::Rack,
  email: {
    email_prefix: PapyrusSettings.errors_email_subject_prefix,
    sender_address: PapyrusSettings.errors_email_from,
    exception_recipients: PapyrusSettings.errors_email_to
  }

  # Papyrus::Application.configure do
  #   config.middleware.use ExceptionNotifier,
  #        email_prefix: PapyrusSettings.errors_email_subject_prefix,
  #        sender_address: PapyrusSettings.errors_email_from,
  #        exception_recipients: PapyrusSettings.errors_email_to
  # end

end
