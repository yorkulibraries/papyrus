namespace :app do
  task set_alma_api_key: :environment do
    setting = PapyrusSettings.find_by! var: 'primo_apikey'
    setting.value = ENV['PRIMO_API_KEY']
    setting.save

    setting = PapyrusSettings.find_by! var: 'alma_apikey'
    setting.value = ENV['ALMA_API_KEY']
    setting.save

    setting = PapyrusSettings.find_by! var: 'worldcat_key'
    setting.value = ENV['WORLDCAT_API_KEY']
    setting.save
  end
end
