## SAMPLE CONFIGURATION OPTIONS

PapyrusConfig.configure do

  ## ORGANIZATION

  organization.full_name = "Your Institution/Department Name"
  organization.short_name = "SHORT_NAME"
  organization.app_url = "http://your-institution.website/papyrus/"
  organization.course_code_sample = "2011_AP_ADMS_F_1000__3_A"
  organization.course_code_lookup_link = "http:://your-institution.website/coursecode-lookup"
  organization.item_sources = ["Publisher", "AERO", "Student Purchase"]

  ## AUTHENTICATION
  authentication.cas_header_name = "REMOTE_USER"
  authentication.cas_alt_header_name = "REMOTE_USER_ID"
  authentication.cas_user_id_name = "Authentication Username"
  authentication.after_logout_redirect_to = "http://www.your-instituttion.website"
  authentication.cookies_domain = "your-domain.com"

  ## ERRORS
  # errors.email_subject_prefix ="[Papyrus Error] "
  # errors.sender_address ="'Papyrus Notifier' <papyrus-errors@your-instituttion.website>"
  # errors.error_recipients = ["your.email@your-instituttion.email"]

  ## NOTIFICATIONS
  # notifications.from_email = "papyrus@your-insitution.email"
  # notifications.welcome_subject = "Welcome to Transcription Services"
  # notifications.notification_subject = "Your Institution/Department Name Transcription Services - Papyrus Notification"
  # notifications.items_assigned_subject = "Multiple item(s) have now been assigned to you"

  ## BIB SEARCH SOLR

  # bib_search.solr.label = "Your Catalogue"
  # bib_search.solr.id_prefix = "solr"
  # bib_search.solr.url = "http://localhost:8080/solr/biblio"
  # bib_search.solr.sort = [ {score: :descending}, {_docid_: :descending} ]
  # bib_search.solr.phrase_fields = "title_txtP^100"
  # bib_search.solr.boost_functions = "recip(ms(NOW,publishDateBoost_tdate),3.16e-11,1,1)^1.0"
  # bib_search.solr.query_fields = "title_short_txtP^757.5   title_short^750  title_full_unstemmed^404   title_full^400   title_txtP^750   title^500   title_alt_txtP_mv^202   title_alt^200   title_new_txtP_mv^101   title_new^100   series^50   series2^30   author^500   author_fuller^150   contents^10   topic_unstemmed^404   topic^400   geographic^300   genre^300   allfields_unstemmed^10   fulltext_unstemmed^10   allfields isbn issn"


  ## BIB SEARCH WORLDCAT
  # bib_search.worldcat.label = "Worlcat Search"
  # bib_search.worldcat.id_prefix = "oclc"
  # bib_search.worlcat.key = "worldcatkey-from-worldcat.org"

end
