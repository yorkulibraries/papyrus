### load papyrus_app_config.rb file if it exsits
papyrus_configuration =  File.expand_path('../../papyrus_app_config.rb', __FILE__)

$config_logger =  Rails.env.production? ? Logger.new(STDERR) : Logger.new("#{Rails.root}/log/config.log")
$config_logger.level = Logger::INFO if Rails.env.production? 
$logger = Rails.logger
$papyrus_config_path = nil


if  File.exists?(papyrus_configuration)
  $logger.debug("Found Configuration file #{papyrus_configuration}")
  $config_logger.debug("Loading from config file #{papyrus_configuration}")
  PapyrusConfig.load(papyrus_configuration)
  PapyrusConfig.instance
  $config_logger.debug("Using configuration for #{PapyrusConfig.organization.full_name}")

else
  $logger.warn("WARNING: Could not find #{papyrus_configuration} file. Using default configuration options. Please create the file if you want to change options.")
  $logger.warn("HINT: You might want to copy papyrus_app_config.default.rb to papyrus_app_config.rb to get started")
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
