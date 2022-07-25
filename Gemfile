source 'http://rubygems.org'
ruby '3.1.2'

## SECURITY FIX ##
gem 'json', '>= 2.3.0'
gem 'rack', '2.2.3.1'
gem 'websocket-extensions', '>= 0.1.5'

## RAILS and server ##
gem 'rails', '~> 7.0.3'

## RAILS related ##
gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'sass-rails', '5.0.8'
gem 'sprockets', '>= 3.7.2'
gem 'uglifier', '>= 1.3.0'

## DATABASES ##
gem 'mysql2', '0.5.3', group: :production

## CSS AND JAVASCRIPT ##
gem 'jquery-rails', '4.3.1'
gem 'jquery-ui-rails', '6.0.1'
gem 'mini_racer'

## BOOTSTRAP && SIMPLE_FORM && FLASH UPLOAD ##
gem 'best_in_place', git: 'https://github.com/mmotherwell/best_in_place'
gem 'bootstrap', '4.5.2'
gem 'font-awesome-sass', '~> 5.13.0'
gem 'simple_form', '~> 5.1'

## TOOLS AND UTILITIES ##
gem 'audited', '~> 5.0'
gem 'cancancan', '~> 3.4'
gem 'devise', '~> 4.8', '>= 4.8.1'
gem 'devise_saml_authenticatable', '1.9.0', github: 'apokalipto/devise_saml_authenticatable'
gem 'email_validator', '1.6.0'
gem 'fullcalendar-rails', '3.0.0.0'
gem 'kaminari', '0.17.0'
gem 'liquid', '4.0.0'
gem 'momentjs-rails', '2.17.1'
gem 'rails-settings-cached', '0.4.1'
gem 'remotipart', '1.3.1' # submit files remotely
gem 'ruby-saml', '~> 1.14'
gem 'rubyzip', '~> 1.3.0'
gem 'search_cop', '1.1.0'
gem 'worldcatapi', git: 'https://github.com/taras-yorku/worldcatapi.git',
                   ref: 'ed6d0cb849e86a032dc84741a5d169da19b8e385'

## EX LIBRIS INTEGRATION ALMA, PRIMO
gem 'alma'
gem 'primo', git: 'https://github.com/tulibraries/primo.git', branch: 'main'

## EXEL EXPORT ##
gem 'axlsx', git: 'https://github.com/randym/axlsx.git'
gem 'axlsx_rails', '0.5.1'
gem 'roo', '~> 2.3.1'

## UPLOADING AND MANIPULATING FILES ##
gem 'carrierwave', '~> 2.2', '>= 2.2.2'
gem 'image_processing', '~> 1.12', '>= 1.12.2'
gem 'mime-types'

# NOTIFICATIONS

gem 'exception_notification', '~> 4.4', '>= 4.4.1'

gem 'awesome_print', '1.8.0'

## CRONJOBS ##
gem 'whenever', require: false

group :test do
  gem 'addressable', '~> 2.8'
  gem 'capybara', '~> 2.13'
  gem 'database_cleaner', '1.6.1'
  gem 'factory_girl', '4.8.0'
  gem 'factory_girl_rails', '4.8.0'
  gem 'guard-bundler', '~> 3.0'
  gem 'guard-minitest', '2.4.6'
  gem 'minitest', '5.10.2'
  gem 'minitest-around'
  gem 'mocha', require: false
  gem 'rails-controller-testing'
  gem 'ruby-prof', '0.16.2'
  gem 'selenium-webdriver'
  gem 'shoulda', '~> 3.6'
  gem 'shoulda-context'
  gem 'webrat', '0.7.3'
end

group :development, :test do
  gem 'byebug'
  gem 'guard-livereload', '2.5.2', require: false
  gem 'rack-livereload', '0.3.16'
  gem 'sqlite3'
  ## PROFILING
  gem 'rack-mini-profiler', require: false
end

group :development do
  gem 'faker'
  gem 'populator', git: 'https://github.com/ryanb/populator.git'
  gem 'web-console', '>= 3.3.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'mimemagic', '~> 0.3.10'
gem 'puma', '~> 5.6', '>= 5.6.4'
