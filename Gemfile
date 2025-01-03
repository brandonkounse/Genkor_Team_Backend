# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.4.1'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.1.3', '>= 7.1.3.4'

# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 2.5'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mswin mswin64 mingw x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# REST client gem for making external API calls
gem 'rest-client', '~> 2.1'

# Firebase Admin SDK Tool
gem 'firebase-admin-sdk', '~> 0.1.2'

# Rate Limiting
gem 'ruby-limiter', '~> 2.2', '>= 2.2.2'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mswin mswin64 mingw x64_mingw]

  # Using dotenv-rails to hide API key for calls to Riot API
  gem 'dotenv-rails', '~> 2.1', '>= 2.1.1'

  # Rubocop Linter
  gem 'rubocop', '~> 1.64', '>= 1.64.1'
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  gem 'error_highlight', '>= 0.4.0', platforms: [:ruby]
end
