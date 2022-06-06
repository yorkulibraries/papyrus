source 'http://rubygems.org'
ruby '2.7.0'

## SECURITY FIX ##
gem "rack", "2.2.3.1"
gem "websocket-extensions", ">= 0.1.5"
gem "json", ">= 2.3.0"

## RAILS and server ##
gem 'rails', '~> 7.0', '>= 7.0.3'

## RAILS related ##
gem 'jbuilder', '~> 2.5'
gem 'bcrypt-ruby', '~> 3.1.2'
gem 'sass-rails', '~> 6.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem "sprockets", ">= 3.7.2"

## DATABASES ##
gem "mysql2", "0.5.3", group: :production

## CSS AND JAVASCRIPT ##
gem 'mini_racer', '~> 0.6.2'
gem 'jquery-rails', '~> 4.5'
gem 'jquery-ui-rails', "6.0.1"

## BOOTSTRAP && SIMPLE_FORM && FLASH UPLOAD ##
gem 'bootstrap', "4.5.2"
gem 'simple_form', '~> 5.1'
gem 'font-awesome-sass', '~> 5.13.0'
gem 'best_in_place', '3.1.1'

## TOOLS AND UTILITIES ##
gem "worldcatapi", git: "https://github.com/taras-yorku/worldcatapi.git", ref: 'ed6d0cb849e86a032dc84741a5d169da19b8e385'
gem 'kaminari', "0.17.0"
gem "cancancan", "2.0.0"
gem 'liquid', '4.0.0'
gem 'email_validator', "1.6.0"
gem 'rails-settings-cached', '~> 0.4.2'
#gem "audited-activerecord", "4.0.0"
gem 'audited', '~> 5.0', '>= 5.0.2'
gem 'remotipart', '1.3.1' # submit files remotely
gem 'fullcalendar-rails', "3.0.0.0"
gem 'momentjs-rails', "2.17.1"
gem 'search_cop', "1.1.0"

## EX LIBRIS INTEGRATION ALMA, PRIMO
gem "alma"
gem "primo", git: "https://github.com/tulibraries/primo.git"

## EXEL EXPORT ##
gem "roo", '~> 2.3.1'
gem 'caxlsx_rails', '~> 0.6.3'

## UPLOADING AND MANIPULATING FILES ##
gem 'carrierwave', '~> 2.2', '>= 2.2.2'
gem "mini_magick", "4.7.1"
gem "mime-types"

# NOTIFICATIONS

gem 'exception_notification', '~> 4.5'

## PROFILING
gem 'rack-mini-profiler', require: false

gem "awesome_print", "1.8.0"

## CRONJOBS ##
gem 'whenever', require: false

group :test do
  gem 'minitest', '~> 5.15'
  gem 'webrat', "0.7.3"
  gem 'factory_girl_rails', "4.8.0"
  gem 'shoulda-matchers'
  gem 'shoulda-context'
  gem "mocha", require: false
  gem "ruby-prof", "0.16.2"
  gem 'database_cleaner', "1.6.1"

  gem "guard-minitest", "2.4.6"
  gem 'guard-bundler', '~> 3.0'
  gem 'capybara', '~> 2.13'
  gem 'addressable', '~> 2.8'
  gem 'selenium-webdriver'

  gem 'rails-controller-testing' ## KEEP THIS AROUND SINCE IT'S USEFUL FOR TESTS in CONTROLLERS
end

group :development, :test do
  gem 'sqlite3', '~> 1.4', '>= 1.4.2'
  gem "rack-livereload", "0.3.16"
  gem 'guard-livereload', "2.5.2", require: false
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
	gem "populator", git: "https://github.com/ryanb/populator.git"
	gem "faker"
  #gem "bullet" # Testing SQL queries
	#gem 'mailcatcher', '~> 0.8.2' # FOR TESTING MAIL. Run mailcatcher, then go to localhost:1080
#  gem 'sinatra', '>= 1.2', '< 2.2'

  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.7', '>= 3.7.1'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'mimemagic', '~> 0.4.3'
gem 'puma', '~> 5.6', '>= 5.6.4'
gem 'bigdecimal', '1.3.5'
gem 'psych', '< 4'
