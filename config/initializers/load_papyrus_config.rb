raw_config = File.read("#{Rails.root}/config/papyrus_config.yml")
APP_CONFIG = HashWithIndifferentAccess.new(YAML.load(raw_config))

# defaults for authentication
if APP_CONFIG[:authentication] == nil || APP_CONFIG[:authentication][:cas_header_name] == nil
  APP_CONFIG[:authentication][:cas_header_name] = "REMOTE-USER"
end

# defaults for organization details
if APP_CONFIG[:organization] == nil || APP_CONFIG[:organization][:full_name] == nil
   APP_CONFIG[:organization][:full_name] = "Your Organization is not set"
   APP_CONFIG[:organization][:short_name] = "SHORT NAME"
end


# Exception Notification For Production 
if Rails.env.production? 
  
  Papyrus::Application.configure do
    config.middleware.use ExceptionNotifier,
         :email_prefix =>  APP_CONFIG[:error_notification][:email_subject_prefix],
         :sender_address => APP_CONFIG[:error_notification][:sender_address],
         :exception_recipients => APP_CONFIG[:error_notification][:error_recipients]
  end       
  
end