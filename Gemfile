source 'http://rubygems.org'
ruby '3.1.2'

## SECURITY FIX ##
gem 'json', '~> 2.6', '>= 2.6.2'
gem 'puma', '~> 5.6', '>= 5.6.4'
gem 'rack', '2.2.3.1'
gem 'rails', '~> 7.0', '>= 7.0.3.1'

## RAILS related ##
gem 'coffee-rails', '~> 4.2'
gem 'sass-rails', '~> 6.0'
gem 'sprockets-rails', '~> 3.4', '>= 3.4.2'
gem 'uglifier', '~> 4.2'

## DATABASES ##
gem 'mysql2', '0.5.3', group: :production

## CSS AND JAVASCRIPT ##
gem 'jquery-rails', '4.3.1'
gem 'jquery-ui-rails', '6.0.1'
gem 'mini_racer', '~> 0.6.3'

## BOOTSTRAP && SIMPLE_FORM && FLASH UPLOAD ##
gem 'best_in_place', git: 'https://github.com/mmotherwell/best_in_place'
gem 'bootstrap', '4.5.2'
gem 'font-awesome-sass', '~> 5.13.0'
gem 'simple_form', '~> 5.1'

## TOOLS AND UTILITIES ##
gem 'audited', '~> 5.0', '>= 5.0.2'
gem 'cancancan', '~> 3.4'
gem 'devise', '~> 4.8', '>= 4.8.1'
gem 'devise_saml_authenticatable', '1.9.0', github: 'apokalipto/devise_saml_authenticatable'
gem 'email_validator', '~> 2.2', '>= 2.2.3'
gem 'fullcalendar-rails', '3.0.0.0'
gem 'kaminari', '~> 1.2', '>= 1.2.2'
gem 'liquid', '~> 5.4'
gem 'momentjs-rails', '2.17.1'
gem 'rails-settings-cached', '0.4.1'
gem 'remotipart', '1.3.1' # submit files remotely
gem 'ruby-saml', '~> 1.14'
gem 'rubyzip', '~> 1.3.0'
gem 'search_cop', '1.1.0'
gem 'worldcatapi', git: 'https://github.com/taras-yorku/worldcatapi.git',
                   ref: 'ed6d0cb849e86a032dc84741a5d169da19b8e385'

## EX LIBRIS INTEGRATION ALMA, PRIMO
gem 'alma', '~> 0.3.3'
gem 'primo', git: 'https://github.com/tulibraries/primo.git', branch: 'main'

## EXEL EXPORT ##
gem 'caxlsx', '3.2.0'
gem 'caxlsx_rails', '0.6.3'
gem 'roo', '~> 2.9'

## UPLOADING AND MANIPULATING FILES ##
gem 'carrierwave', '~> 2.2', '>= 2.2.2'
gem 'image_processing', '~> 1.12', '>= 1.12.2'
gem 'mime-types', '~> 3.4', '>= 3.4.1'

# NOTIFICATIONS

gem 'exception_notification', '~> 4.5'

## CRONJOBS ##
gem 'whenever', require: false

group :test do
  gem 'database_cleaner', '~> 2.0', '>= 2.0.1'
  gem 'factory_girl_rails', '4.8.0'
  gem 'guard-bundler', '~> 3.0'
  gem 'guard-minitest', '2.4.6'
  gem 'minitest', '~> 5.16', '>= 5.16.3'
  gem 'minitest-around', '~> 0.5.0'
  gem 'rails-controller-testing', '~> 1.0', '>= 1.0.5'
  gem 'shoulda', '~> 3.6'
end

group :development, :test do
  gem 'byebug', '~> 11.1', '>= 11.1.3'
  gem 'guard-livereload', '2.5.2', require: false
  gem 'sqlite3', '~> 1.4', '>= 1.4.4'
end

group :development do
  gem 'faker', '~> 2.22'
  gem 'populator', git: 'https://github.com/ryanb/populator.git'
  gem 'web-console', '>= 3.3.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
