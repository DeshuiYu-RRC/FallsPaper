source "https://rubygems.org"

ruby "3.2.2"

# Rails framework
gem "rails", "~> 7.1.0"

# Database
gem "mysql2", "~> 0.5"

# Web server
gem "puma", ">= 5.0"

# Asset pipeline
gem "sprockets-rails"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"

# CSS/JS bundling
gem "cssbundling-rails"
gem "jsbundling-rails"

# JSON APIs
gem "jbuilder"

# Authentication (Devise)
gem "devise", "~> 4.9"

# Admin Dashboard (ActiveAdmin)
gem "activeadmin", "~> 3.0"

# Pagination (Kaminari - required, will_paginate conflicts with ActiveAdmin)
gem "kaminari", "~> 1.2"

# Image processing
gem "image_processing", "~> 1.2"

# SCSS support
gem "sassc-rails"

# Bootstrap for styling
gem "bootstrap", "~> 5.3"

# Windows timezone data
gem "tzinfo-data", platforms: %i[windows jruby]

# Reduces boot times through caching
gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[mri windows]
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
end

group :development do
  gem "web-console"
  gem "error_highlight", ">= 0.4.0", platforms: [:ruby]
  gem "rubocop", require: false
  gem "rubocop-rails", require: false
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
gem 'stripe'
