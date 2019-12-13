require 'alma'
require 'primo'

Alma.configure do |config|
  config.apikey = PapyrusSettings.alma_apikey
  config.region = PapyrusSettings.alma_region
end

Primo.configure do |config|
  config.apikey = PapyrusSettings.primo_apikey
  config.inst = PapyrusSettings.primo_inst
  config.vid = PapyrusSettings.primo_vid
  config.region = PapyrusSettings.primo_region
  config.enable_loggable = PapyrusSettings.primo_enable_loggable
  config.scope = PapyrusSettings.primo_scope
  config.pcavailability = PapyrusSettings.primo_pcavailability
end
