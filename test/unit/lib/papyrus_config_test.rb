require 'test_helper'
require "papyrus_config"

class PapyrusConfigTest < ActiveSupport::TestCase

  setup do
    PapyrusConfig.reset_defaults
  end
  
  should "create one instance of PapyrusConfig" do
    instance = PapyrusConfig.config
    instance2 = PapyrusConfig.config
    assert_equal instance, instance2 
  end
  
  should "create itself with default subsections" do
    instance = PapyrusConfig.config
    
    assert_not_nil instance.organization, "Organization is required"
    assert_not_nil instance.authentication, "Authentication is required"
    assert_not_nil instance.errors, "Errors is required"
    assert_not_nil instance.notifications, "Notifications is required"
    assert_not_nil instance.bib_search, "Bib search is required"                    
  end
  
  should "set defaults for each subsection" do
    instance = PapyrusConfig.config
    
    ## ORGANIZATION
    assert_equal "Your Institution/Department Name", instance.organization.full_name
    assert_equal "SHORT_NAME", instance.organization.short_name
    assert_equal "http://your-institution.website/papyrus/", instance.organization.app_url
  
    ## AUTHENTICATION
    assert_equal "REMOTE-USER", instance.authentication.cas_header_name
    assert_equal "Authentication Username", instance.authentication.cas_user_id_name
    assert_equal "http://www.your-instituttion.website", instance.authentication.after_logout_redirect_to    
    assert_equal "your-domain.com", instance.authentication.cookies_domain
    
    ## ERRORS
    assert_equal "[Papyrus Error] ", instance.errors.email_subject_prefix
    assert_equal "'Papyrus Notifier' <papyrus-errors@your-instituttion.website>", instance.errors.sender_address
    assert_equal ["your.email@your-instituttion.email"], instance.errors.error_recipients       

    ## NOTIFICATIONS
    assert_equal "papyrus@your-insitution.email", instance.notifications.from_email
    assert_equal "Welcome to Transcription Services", instance.notifications.welcome_subject
    assert_equal "Your Institution/Department Name Transcription Services - Papyrus Notification", instance.notifications.notification_subject
    assert_equal "Multiple items have now been assigned to you", instance.notifications.items_assigned_subject             
    
    ## BIB_SEARCH
    assert_equal "solr", instance.bib_search.type
    assert_equal "Your Catalogue", instance.bib_search.label    
    assert_equal "vufind", instance.bib_search.id_prefix
    assert_equal "http://localhost:8080/solr/biblio", instance.bib_search.url
    
    query_fields = "title_short_txtP^757.5   title_short^750  title_full_unstemmed^404   title_full^400   title_txtP^750   title^500   title_alt_txtP_mv^202   title_alt^200   title_new_txtP_mv^101   title_new^100   series^50   series2^30   author^500   author_fuller^150   contents^10   topic_unstemmed^404   topic^400   geographic^300   genre^300   allfields_unstemmed^10   fulltext_unstemmed^10   allfields isbn issn"
    assert_equal query_fields, instance.bib_search.query_fields
    
    assert_equal  "title_txtP^100", instance.bib_search.phrase_fields
    assert_equal "recip(ms(NOW,publishDateBoost_tdate),3.16e-11,1,1)^1.0", instance.bib_search.boost_functions
    assert_equal [ { score: "descending" } , { _docid_: "descending" } ], instance.bib_search.sort
    
    
  end
  
  should "update configuration options using configure" do
    PapyrusConfig.configure do |config|
      config.bib_search.type = "worldcat"
      config.organization.short_name = "new_name"
      config.notifications.from_email = "new@email.com"
    end
    
    assert_equal "worldcat", PapyrusConfig.config.bib_search.type, "Type changed"
    assert_equal "vufind", PapyrusConfig.config.bib_search.id_prefix, "ID Prefix hasn't changed"
    
    assert_equal "new_name", PapyrusConfig.config.organization.short_name, "Organization short name changed"
    assert_equal "new@email.com", PapyrusConfig.config.notifications.from_email, "From Email changed"
    
  end
  
  should "have class methods to access each config option" do
    instance = PapyrusConfig.config
    
    assert_equal PapyrusConfig.organization, instance.organization, "Organization object is the same"
    assert_equal PapyrusConfig.authentication, instance.authentication, "authentication object is the same"
    assert_equal PapyrusConfig.errors, instance.errors, "errors object is the same"
    assert_equal PapyrusConfig.notifications, instance.notifications, "notifications object is the same"
    assert_equal PapyrusConfig.bib_search, instance.bib_search, "bib_search object is the same"                
    
  end
end