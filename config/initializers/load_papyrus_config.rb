### load papyrus_app_config.rb file if it exsits
papyrus_configuration =  File.expand_path('../../papyrus_app_config.rb', __FILE__)

if  File.exists?(papyrus_configuration)
  Rails.logger.debug("Found Configuration file. Using it.")
  require papyrus_configuration
else
  Rails.logger.warn("WARNING: Could not find #{papyrus_configuration} file. Using default configuration options. Please create the file if you want to change options.")
  Rails.logger.warn("HINT: You might want to copy papyrus_app_config.default.rb to papyrus_app_config.rb to get started")
end

# Exception Notification For Production 
if Rails.env.production? 
  
  Papyrus::Application.configure do
    config.middleware.use ExceptionNotifier,
         :email_prefix => PapyrusConfig.errors.email_subject_prefix,
         :sender_address => PapyrusConfig.errors.sender_address,
         :exception_recipients => PapyrusConfig.errors.error_recipients
  end       
  
end