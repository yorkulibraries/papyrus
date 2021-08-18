source 'http://rubygems.org'

## SECURITY FIX ##
gem "rack", "2.2.3"
gem "websocket-extensions", ">= 0.1.5"
gem "json", ">= 2.3.0"

## RAILS and server ##
gem "rails", "5.1.6.2"
gem "puma", ">= 3.12.6"
gem "puma-plugin-systemd"

## RAILS related ##
gem 'jbuilder', '~> 2.5'
gem 'bcrypt-ruby', '~> 3.1.2'
gem 'sass-rails', '5.0.6'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem "sprockets", ">= 3.7.2"

## DATABASES ##
gem 'sqlite3'
gem "mysql2", "0.5.3"

## CSS AND JAVASCRIPT ##
#gem 'therubyracer', "0.12.3", platforms: :ruby
gem "mini_racer"
gem 'jquery-rails', "4.3.1"
gem 'jquery-ui-rails', "6.0.1"

## BOOTSTRAP && SIMPLE_FORM && FLASH UPLOAD ##
gem 'bootstrap', "4.5.2"
#gem "less-rails", "2.8.0"
gem "simple_form", "3.5.0"
gem 'font-awesome-sass', '~> 5.13.0'
gem 'best_in_place', '3.1.1'

## TOOLS AND UTILITIES ##
gem "worldcatapi", "1.0.5"
gem 'kaminari', "0.17.0"
gem "cancancan", "2.0.0"
gem 'liquid', '4.0.0'
gem 'email_validator', "1.6.0"
gem "rails-settings-cached", "0.4.1"
#gem "audited-activerecord", "4.0.0"
gem "audited", "~> 4.5"
gem 'remotipart', '1.3.1' # submit files remotely
gem 'fullcalendar-rails', "3.0.0.0"
gem 'momentjs-rails', "2.17.1"
gem "rubyzip", "~> 1.2.2"
gem 'search_cop', "1.1.0"
#gem "nokogiri", "~> 1.8.2"

## EX LIBRIS INTEGRATION ALMA, PRIMO
gem "alma"
gem "primo", git: "https://github.com/tulibraries/primo.git"

## EXEL EXPORT ##
gem "roo", '~> 2.3.1'
gem "axlsx", git: 'https://github.com/randym/axlsx.git'
gem 'axlsx_rails', "0.5.1"

## UPLOADING AND MANIPULATING FILES ##
gem "carrierwave", "1.1.0"
gem "mini_magick", "4.7.1"
gem "mime-types"

# NOTIFICATIONS

gem 'exception_notification', "4.2.1"

## PROFILING
gem 'rack-mini-profiler', require: false


gem 'guard-livereload', "2.5.2", require: false
gem "rack-livereload", "0.3.16"
gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
gem "awesome_print", "1.8.0"

## CRONJOBS ##
gem 'whenever', require: false

group :test do
  gem "minitest", "5.10.2"
  gem 'webrat', "0.7.3"
  gem 'factory_girl_rails', "4.8.0"
  gem 'shoulda', "3.5"
  gem 'shoulda-matchers'
  gem 'shoulda-context'
  gem "mocha", require: false
  gem "ruby-prof", "0.16.2"
  gem 'database_cleaner', "1.6.1"

  gem "guard-minitest", "2.4.6"

  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'

  gem 'rails-controller-testing' ## KEEP THIS AROUND SINCE IT'S USEFUL FOR TESTS in CONTROLLERS
  gem 'spring', "2.0.2"
  gem 'spring-watcher-listen', '~> 2.0.0'

end


group :development do
	gem "populator", git: "https://github.com/ryanb/populator.git"
	gem "faker"
  #gem "bullet" # Testing SQL queries
	gem "mailcatcher" # FOR TESTING MAIL. Run mailcatcher, then go to localhost:1080
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
