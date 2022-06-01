# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)



if Rails.env != 'test' and User.all.count == 0
User.create!([
  {username: "admin", last_name: "User", role: "admin", inactive: false, type: nil, email: "admin@me.ca", created_by_user_id: nil, email_sent_at: nil, blocked: false, last_logged_in_at: "2022-05-25 14:32:52", first_name: "Admin", last_active_at: "2022-05-25 14:32:52", first_time_login: true},
  {username: "cordinator", last_name: "User", role: "coordinator", inactive: false, type: nil, email: "coordinator@me.ca", created_by_user_id: nil, email_sent_at: nil, blocked: false, last_logged_in_at: nil, first_name: "Coordinator", last_active_at: nil, first_time_login: true},
])
Student.create!([
  {username: "student", last_name: "User", role: "student", inactive: false, type: "Student", email: "student@me.ca", created_by_user_id: 1, email_sent_at: nil, blocked: false, last_logged_in_at: nil, first_name: "student", last_active_at: nil, first_time_login: true}
])
StudentDetails.create!([
  {student_id: 3, student_number: 3333333, preferred_phone: "33333333", cds_counsellor: "", format_pdf: true, format_kurzweil: false, format_daisy: false, format_braille: false, format_note: "", transcription_coordinator_id: 2, request_form_signed_on: nil, transcription_assistant_id: 2, format_word: false, format_large_print: false, requires_orientation: true, orientation_completed: false, orientation_completed_at: nil, book_retrieval: false, accessibility_lab_access: false, cds_counsellor_email: "counsellor@me.ca", alternate_format_required: true, format_other: false, format_epub: false}
])
end 

if PapyrusSettings.count == 0
PapyrusSettings.create!([
  {var: "app_name", value: "Papyrus", thing_id: nil, thing_type: nil},
  {var: "app_owner", value: "York University Libraries", thing_id: nil, thing_type: nil},
  {var: "org_name", value: "York University Libraries", thing_id: nil, thing_type: nil},
  {var: "org_short_name", value: "YUL", thing_id: nil, thing_type: nil},
  {var: "org_app_url", value: "http://papyrus.me.ca", thing_id: nil, thing_type: nil},
  {var: "course_code_sample", value: "2011_AP_ADMS_F_1000__3_A", thing_id: nil, thing_type: nil},
  {var: "course_lookup_url", value: "http://coursecode.yorku.ca", thing_id: nil, thing_type: nil},
  {var: "item_sources", value: "", thing_id: nil, thing_type: nil},
  {var: "auth_cas_header", value: "HTTP_PYORK_USER", thing_id: nil, thing_type: nil},
  {var: "auth_cas_header_alt", value: "HTTP_PYORK_USER", thing_id: nil, thing_type: nil},
  {var: "auth_cas_user_id_label", value: "Same as Student Number", thing_id: nil, thing_type: nil},
  {var: "auth_cas_logout_redirect", value: "https://www.library.yorku.ca", thing_id: nil, thing_type: nil},
  {var: "auth_cookies_domain", value: "yorku.ca", thing_id: nil, thing_type: nil},
  {var: "errors_email_subject_prefix", value: "[Papyrus Error]", thing_id: nil, thing_type: nil},
  {var: "errors_email_from", value: "'Papyrus Notifier' <papyrus-errors@me.ca>", thing_id: nil, thing_type: nil},
  {var: "errors_email_to", value: "papyrus@me.ca", thing_id: nil, thing_type: nil},
  {var: "email_allow", value: "true", thing_id: nil, thing_type: nil},
  {var: "email_from", value: "papyrus-mailer@me.ca", thing_id: nil, thing_type: nil},
  {var: "email_welcome_subject", value: "Welcome to Transcription Services", thing_id: nil, thing_type: nil},
  {var: "email_welcome_body", value: "Hello {{student_name}}!\r\n------------------------------------------------------\r\n\r\nWelcome to Library Accessibility Services\r\n\r\nThis is an email confirmation you have been registered with Library Accessibility Services.\r\nWe are here to provide equitable access to the full range of library services, resources and facilities for students, faculty and staff.\r\nYou will be receiving a communication email which will have contact information of your Library Accessibility Services team member who will be assisting you.\r\n\r\nSincerely,\r\nLibrary Accessibility Services\r\n\r\nPlease see our website Library Accessibility Services for more information:\r\nhttp://www.library.yorku.ca/web/ask-services/accessibility-services/\r\n\r\n+++++++++\r\nPlease do not reply to this message; it was sent from an unmonitored email address.  Please send all inquiries to papyrus@me.ca\r\n", thing_id: nil, thing_type: nil},
  {var: "email_notification_subject", value: "York University Libraries Transcription Services - Papyrus Notification", thing_id: nil, thing_type: nil},
  {var: "email_notification_body", value: "Hello, {{student_name}}\r\n \r\nThis is a message from Library's Accessibility Application - Papyrus      \r\n\r\nMessage\r\n===============================================\r\n\r\n{{message}}\r\n\r\n===============================================\r\n\r\nTo login to the site, just follow this link: {{application_url}}. \r\n\r\nYou must have a Passport York Account to Log in.\r\n \r\nThanks and have a great day!", thing_id: nil, thing_type: nil},
  {var: "email_item_assigned_subject", value: "Multiple item(s) have now been assigned to you", thing_id: nil, thing_type: nil},
  {var: "email_item_assigned_body", value: "Hello  {{student_name}} \r\n\r\nThe following item(s) have now been assigned to you and are available for download: \r\n\r\n\r\n-----\r\n\r\n{{items}}\r\n\r\n-----\r\n\r\nPlease login to the Papyrus website to access the material: {{application_url}}\r\n\r\nShould you have any questions, please contact your transcription assistant. \r\n\r\n+++++++++\r\nPlease do not reply to this message; it was sent from an unmonitored email address. This message is a service email related to your use of Papyrus. For general inquiries or to request support with your Papyrus, please contact papyrus@me.ca\r\n", thing_id: nil, thing_type: nil},
  {var: "vufind_url", value: "https://vufind.org", thing_id: nil, thing_type: nil},
  {var: "vufind_label", value: "Vufind", thing_id: nil, thing_type: nil},
  {var: "vufind_id_prefix", value: "vufind", thing_id: nil, thing_type: nil},
  {var: "worldcat_key", value: "iyourkeyhere", thing_id: nil, thing_type: nil},
  {var: "worldcat_label", value: "WorldCat", thing_id: nil, thing_type: nil},
  {var: "worldcat_id_prefix", value: "oclc", thing_id: nil, thing_type: nil},
  {var: "reports_default_interval", value: "'2592000'", thing_id: nil, thing_type: nil},
  {var: "reports_fiscal_year_start", value: "May 1", thing_id: nil, thing_type: nil},
  {var: "email_acquisitions_to", value: "acquisition@me.ca", thing_id: nil, thing_type: nil},
  {var: "email_acquisitions_to_bookstore", value: "bookstore@me.ca", thing_id: nil, thing_type: nil},
  {var: "email_acquisitions_subject", value: "Please Acquire This Item for Library Accessibility Services", thing_id: nil, thing_type: nil},
  {var: "email_acquisitions_body", value: "Please deliver to Library Accessibility Services Scott Library", thing_id: nil, thing_type: nil},
  {var: "acquisition_sources", value: "", thing_id: nil, thing_type: nil},
  {var: "acquisition_reasons", value: "", thing_id: nil, thing_type: nil},
  {var: "course_sync_on_login", value: "false", thing_id: nil, thing_type: nil},
  {var: "course_listing_header", value: "HTTP_PYORK_COURSES", thing_id: nil, thing_type: nil},
  {var: "course_listing_separator", value: ",", thing_id: nil, thing_type: nil},
  {var: "term_fall_start", value: "Sep 1", thing_id: nil, thing_type: nil},
  {var: "term_fall_end", value: "Dec 31", thing_id: nil, thing_type: nil},
  {var: "term_winter_start", value: "Jan 1", thing_id: nil, thing_type: nil},
  {var: "term_winter_end", value: "April 30", thing_id: nil, thing_type: nil},
  {var: "term_year_start", value: "Sep 1", thing_id: nil, thing_type: nil},
  {var: "term_year_end", value: "April 30", thing_id: nil, thing_type: nil},
  {var: "term_summer_start", value: "May 1", thing_id: nil, thing_type: nil},
  {var: "term_summer_end", value: "Aug 31", thing_id: nil, thing_type: nil},
  {var: "profiler_enable", value: "false", thing_id: nil, thing_type: nil},
  {var: "import_auto_assign_coordinator", value: "true", thing_id: nil, thing_type: nil},
  {var: "import_send_welcome_email_to_student", value: "true", thing_id: nil, thing_type: nil},
  {var: "import_notify_coordinator", value: "true", thing_id: nil, thing_type: nil},
  {var: "student_portal_welcome_message", value: "Welcome to Papyrus please verify all your account information.", thing_id: nil, thing_type: nil},
  {var: "student_portal_welcome_enable", value: "true", thing_id: nil, thing_type: nil},
  {var: "api_enable", value: "true", thing_id: nil, thing_type: nil},
  {var: "api_http_auth_enable", value: "true", thing_id: nil, thing_type: nil},
  {var: "api_http_auth_user", value: "papyrus_api", thing_id: nil, thing_type: nil},
  {var: "api_http_auth_pass", value: "secret-api", thing_id: nil, thing_type: nil},
  {var: "email_lab_access_enable", value: "false", thing_id: nil, thing_type: nil},
  {var: "email_lab_access_subject", value: "Lab Access Only Subject", thing_id: nil, thing_type: nil},
  {var: "email_lab_access_body", value: "Lab Access Only Body", thing_id: nil, thing_type: nil},
  {var: "primo_apikey", value: "yourkey", thing_id: nil, thing_type: nil},
  {var: "primo_inst", value: "01OCUL_YOR", thing_id: nil, thing_type: nil},
  {var: "primo_vid", value: "01OCUL_YOR:YOR_DEFAULT", thing_id: nil, thing_type: nil},
  {var: "primo_region", value: "https://api-na.hosted.exlibrisgroup.com", thing_id: nil, thing_type: nil},
  {var: "primo_enable_loggable", value: "true", thing_id: nil, thing_type: nil},
  {var: "primo_scope", value: "MyInst_and_CI", thing_id: nil, thing_type: nil},
  {var: "primo_pcavailability", value: "true", thing_id: nil, thing_type: nil},
  {var: "alma_apikey", value: "apikeyhere", thing_id: nil, thing_type: nil},
  {var: "alma_region", value: "https://api-na.hosted.exlibrisgroup.com", thing_id: nil, thing_type: nil}
])
end
