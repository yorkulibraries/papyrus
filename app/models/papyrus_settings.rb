# frozen_string_literal: true

class PapyrusSettings < RailsSettings::Base
  cache_prefix { 'v1' }

  TRUE = 'true'
  FALSE = 'false'
  field :app_name, default: ENV['app_name'] || 'Papyrus'
  field :app_owner, default: ENV['app_owner'] || 'York University Libraries'
  field :org_name, default: ENV['org_name'] || 'York University Libraries'
  field :org_short_name, default: ENV['org_short_name'] || 'YUL'
  field :org_app_url, default: ENV['org_app_url'] || 'http://papyrus.me.ca'
  field :course_code_sample, default: ENV['course_code_sample'] || '2011_AP_ADMS_F_1000__3_A'
  field :course_lookup_url, default: ENV['course_lookup_url'] || 'http://coursecode.yorku.ca'
  field :item_sources, default: ENV['item_sources'] || []
  field :auth_cas_header, default: ENV['auth_cas_header'] || 'HTTP_PYORK_USER'
  field :auth_cas_header_alt, default: ENV['auth_cas_header_alt'] || 'HTTP_PYORK_USER'
  field :auth_cas_user_id_label, default: ENV['auth_cas_user_id_label'] || 'Same as Student Number'
  field :auth_cas_logout_redirect, default: ENV['auth_cas_logout_redirect'] || 'https://www.library.yorku.ca'
  field :auth_cookies_domain, default: ENV['auth_cookies_domain'] || 'yorku.ca'
  field :errors_email_subject_prefix, default: ENV['errors_email_subject_prefix'] || '[Papyrus Error]'
  field :errors_email_from, default: ENV['errors_email_from'] || "'Papyrus Notifier' <papyrus@mailinator.com>"
  field :errors_email_to, default: ENV['errors_email_to'] || 'papyrus@me.ca'
  field :email_allow, default: ENV['email_allow'] || true
  field :email_from, default: ENV['email_from'] || 'papyrus@mailinator.com'
  field :email_welcome_subject, default: ENV['email_welcome_subject'] || 'Welcome to Transcription Services'
  field :email_welcome_body,
        default: ENV['email_welcome_body'] || "Hello {{student_name}}!\r\n------------------------------------------------------\r\n\r\nWelcome to Library Accessibility Services\r\n\r\nThis is an email confirmation you have been registered with Library Accessibility Services.\r\nWe are here to provide equitable access to the full range of library services, resources and facilities for students, faculty and staff.\r\nYou will be receiving a communication email which will have contact information of your Library Accessibility Services team member who will be assisting you.\r\n\r\nSincerely,\r\nLibrary Accessibility Services\r\n\r\nPlease see our website Library Accessibility Services for more information:\r\nhttp://www.library.yorku.ca/web/ask-services/accessibility-services/\r\n\r\n+++++++++\r\nPlease do not reply to this message; it was sent from an unmonitored email address.  Please send all inquiries to papyrus@me.ca\r\n"
  field :email_notification_subject,
        default: ENV['email_notification_subject'] || 'York University Libraries Transcription Services - Papyrus Notification'
  field :email_notification_body,
        default: ENV['email_notification_body'] || "Hello, {{student_name}}\r\n \r\nThis is a message from Library's Accessibility Application - Papyrus      \r\n\r\nMessage\r\n===============================================\r\n\r\n{{message}}\r\n\r\n===============================================\r\n\r\nTo login to the site, just follow this link: {{application_url}}. \r\n\r\nYou must have a Passport York Account to Log in.\r\n \r\nThanks and have a great day!"
  field :email_item_assigned_subject,
        default: ENV['email_item_assigned_subject'] || 'Multiple item(s) have now been assigned to you'
  field :email_item_assigned_body,
        default: ENV['email_item_assigned_body'] || "Hello  {{student_name}} \r\n\r\nThe following item(s) have now been assigned to you and are available for download: \r\n\r\n\r\n-----\r\n\r\n{{items}}\r\n\r\n-----\r\n\r\nPlease login to the Papyrus website to access the material: {{application_url}}\r\n\r\nShould you have any questions, please contact your transcription assistant. \r\n\r\n+++++++++\r\nPlease do not reply to this message; it was sent from an unmonitored email address. This message is a service email related to your use of Papyrus. For general inquiries or to request support with your Papyrus, please contact papyrus@me.ca\r\n"
  field :vufind_url, default: ENV['vufind_url'] || 'https://vufind.org'
  field :vufind_label, default: ENV['vufind_label'] || 'Vufind'
  field :vufind_id_prefix, default: ENV['vufind_id_prefix'] || 'vufind'
  field :worldcat_key, default: ENV['WORLDCAT_API_KEY'] || 'iyourkeyhere'
  field :worldcat_label, default: ENV['worldcat_label'] || 'WorldCat'
  field :worldcat_id_prefix, default: ENV['worldcat_id_prefix'] || 'oclc'
  field :reports_default_interval, default: ENV['reports_default_interval'] || "'2592000'"
  field :reports_fiscal_year_start, default: ENV['reports_fiscal_year_start'] || 'May 1'
  field :email_acquisitions_to, default: ENV['email_acquisitions_to'] || 'acquisition@me.ca'
  field :email_acquisitions_to_bookstore, default: ENV['email_acquisitions_to_bookstore'] || 'bookstore@me.ca'

  field :email_acquisitions_subject,
        default: ENV['email_acquisitions_subject'] || 'Please Acquire This Item for Library Accessibility Services'
  field :email_acquisitions_body,
        default: ENV['email_acquisitions_body'] || 'Please deliver to Library Accessibility Services Scott Library'
  field :acquisition_sources, default: ENV['acquisition_sources'] || []
  field :acquisition_reasons, default: ENV['acquisition_reasons'] || []
  field :course_sync_on_login, default: ENV['course_sync_on_login'] || false
  field :course_listing_header, default: ENV['course_listing_header'] || 'HTTP_PYORK_COURSES'
  field :course_listing_separator, default: ENV['course_listing_separator'] || ','
  field :term_fall_start, default: ENV['term_fall_start'] || 'Sep 1'
  field :term_fall_end, default: ENV['term_fall_end'] || 'Dec 31'
  field :term_winter_start, default: ENV['term_winter_start'] || 'Jan 1'
  field :term_winter_end, default: ENV['term_winter_end'] || 'April 30'
  field :term_year_start, default: ENV['term_year_start'] || 'Sep 1'
  field :term_year_end, default: ENV['term_year_end'] || 'April 30'
  field :term_summer_start, default: ENV['term_summer_start'] || 'May 1'
  field :term_summer_end, default: ENV['term_summer_end'] || 'Aug 31'
  field :profiler_enable, default: ENV['profiler_enable'] || false
  field :import_auto_assign_coordinator, default: ENV['import_auto_assign_coordinator'] || true
  field :import_send_welcome_email_to_student, default: ENV['import_send_welcome_email_to_student'] || true
  field :import_notify_coordinator, default: ENV['import_notify_coordinator'] || true
  field :student_portal_welcome_message,
        default: ENV['student_portal_welcome_message'] || 'Welcome to Papyrus please verify all your account information.'
  field :student_portal_welcome_enable, default: ENV['student_portal_welcome_enable'] || true
  field :api_enable, default: ENV['api_enable'] || true
  field :api_http_auth_enable, default: ENV['api_http_auth_enable'] || true
  field :api_http_auth_user, default: ENV['api_http_auth_user'] || 'papyrus_api'
  field :api_http_auth_pass, default: ENV['api_http_auth_pass'] || 'secret-api'
  field :email_lab_access_enable, default: ENV['email_lab_access_enable'] || false
  field :email_lab_access_subject, default: ENV['email_lab_access_subject'] || 'Lab Access Only Subject'
  field :email_lab_access_body, default: ENV['email_lab_access_body'] || 'Lab Access Only Body'
  field :primo_apikey, default: ENV['PRIMO_API_KEY'] || 'yourkey'
  field :primo_inst, default: ENV['primo_inst'] || '01OCUL_YOR'
  field :primo_vid, default: ENV['primo_vid'] || '01OCUL_YOR:YOR_DEFAULT'
  field :primo_region, default: ENV['primo_region'] || 'https://api-na.hosted.exlibrisgroup.com'
  field :primo_enable_loggable, default: ENV['primo_enable_loggable'] || true
  field :primo_scope, default: ENV['primo_scope'] || 'MyInst_and_CI'
  field :primo_pcavailability, default: ENV['primo_pcavailability'] || true
  field :alma_apikey, default: ENV['ALMA_API_KEY'] || 'apikeyhere'
  field :alma_region, default: ENV['alma_region'] || 'https://api-na.hosted.exlibrisgroup.com'
end
