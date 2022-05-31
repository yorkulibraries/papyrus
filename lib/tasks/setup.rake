namespace :app do
  task :set_alma_api_key => :environment do
    primo_apikey = PapyrusSettings.find_by! var: 'primo_apikey'
    primo_apikey.value = ENV['PRIMO_API_KEY']
    primo_apikey.save

    alma_apikey = PapyrusSettings.find_by! var: 'alma_apikey'
    alma_apikey.value = ENV['ALMA_API_KEY']
    alma_apikey.save
  end
end
