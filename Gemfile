source 'https://rubygems.org'

#ruby-gemset=directory
ruby '2.1.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.1'

# Load Mongoid from github to be compatible with Rails 4
gem 'mongoid', '~> 4.0.0'

# Pagination made simpler
gem 'kaminari'

# Custom serializer for better json api
gem 'active_model_serializers'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# A javascript date library for parsing, validating, manipulating, and formatting dates
gem 'momentjs-rails'

# Import easily AngularJS
gem 'angularjs-rails'

# Use Bootstrap as sass framework
gem 'anjlab-bootstrap-rails', :require => 'bootstrap-rails'

# Use font-awesome icons
gem 'font-awesome-sass'

# Generate cron tasks easily
gem 'whenever'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# Client library for elasticsearch
gem 'tire'
gem 'tire-am_serializers'

# Client library for LDAP connection
gem 'net-ldap', '~> 0.6'

# Use devise as authentication solution
gem 'devise'
gem 'devise_invitable'

# Use Carrierwave Image uploader
gem 'carrierwave'
gem 'carrierwave-mongoid'

# Image processing using ImageMagick
gem 'mini_magick'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development, :test do
  gem 'rspec-rails', '~> 3.0'
  gem 'fabrication'
  gem 'teaspoon'
  gem 'zeus', '>= 0.13.4.pre2'
  gem 'quiet_assets'
end

group :test do
  gem 'capybara'
  gem 'webmock'
  gem 'simplecov', require: false
end

# Use unicorn as the app server
gem 'unicorn'
