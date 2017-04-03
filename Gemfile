source 'http://rubygems.org'

## RAILS and related ##
gem "rails", "4.2.6"
gem 'responders', '~> 2.0'

## RAILS related ##
gem 'jbuilder', '~> 1.2'
gem 'bcrypt-ruby', '~> 3.1.2'

## DEPLOYMENT ##
gem 'capistrano', '3.8.0'
gem 'capistrano-rails', '1.2.3'
gem 'capistrano-bundler', "1.2.0"
gem 'capistrano-rbenv', "2.1.0"

## DATABASES ##
gem 'sqlite3'
gem "mysql2", "0.4.4"

## CSS AND JAVASCRIPT ##
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'therubyracer', platforms: :ruby
gem 'jquery-rails', "4.0.5"
gem 'jquery-ui-rails', "5.0.5"

## BOOTSTRAP && SIMPLE_FORM && FLASH UPLOAD ##
gem 'twitter-bootstrap-rails', "3.2.0"
gem "less-rails", "2.7.1"
gem "simple_form", "3.1.0"
gem "font-awesome-rails", '4.7.0.0'
gem 'best_in_place', '~> 3.0.1'

## TOOLS AND UTILITIES ##
gem "worldcatapi", "1.0.5"
gem 'kaminari', "0.15.1"
gem "cancan", "1.6.9"
gem "rubyzip", "0.9.9"
gem 'liquid', '2.6.2'
gem 'email_validator', "1.4.0"
gem "rails-settings-cached", "0.4.1"
gem "audited-activerecord", "4.0.0"
gem 'remotipart', '1.3.1' # submit files remotely
gem 'fullcalendar-rails', "3.0.0.0"
gem 'momentjs-rails', "2.15.1"

## EXEL EXPORT ##
gem "roo", "1.13.2"
gem "axlsx", "2.0.0"
gem 'axlsx_rails', "0.1.5"

## UPLOADING AND MANIPULATING FILES ##
gem "carrierwave", "0.10.0"
gem "mini_magick", "3.7.0"
gem "mime-types", "1.25.1"

# NOTIFICATIONS

gem 'exception_notification', "4.1.4"

## PROFILING
gem 'rack-mini-profiler', require: false

## TESTING && DEVELOPMENT ##
gem 'guard-livereload', require: false
gem "rack-livereload"

group :test do
  gem "minitest", "5.6.1"
  gem 'webrat', "0.7.3"
  gem 'factory_girl_rails', "4.5.0"
  gem 'shoulda', "3.5"
  gem 'shoulda-matchers'
  gem 'shoulda-context'
  gem "mocha", "0.14", require: false
  gem "capybara", "2.1.0"
  gem 'database_cleaner', "1.2.0"
  gem "guard-minitest", "2.4.4"
  gem 'spring', "1.3.6"
  gem "ruby-prof"

end


group :development do
  gem 'nifty-generators', "0.4.6"
	gem "populator", git: "https://github.com/ryanb/populator.git"
	gem "faker"
  gem "bullet" # Testing SQL queries
	gem "mailcatcher" # FOR TESTING MAIL. Run mailcatcher, then go to localhost:1080

end
