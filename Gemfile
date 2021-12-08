# frozen_string_literal: true

source 'https://rubygems.org'
ruby File.read('.ruby_version').strip

# Configuration and Utilities
gem 'figaro', '~> 1.2'
gem 'rake'

# Web Application
gem 'puma', '~> 5.5'
gem 'roda', '~> 3.49'
gem 'slim', '~> 4.1'
gem 'rack', '~> 2' # 2.3 will fix delegateclass bug

# Controllers and services
gem 'dry-monads', '~> 1.4'
gem 'dry-transaction', '~> 0.13'
gem 'dry-validation', '~> 1.7'

# Validation
gem 'dry-struct', '~> 1.4'
gem 'dry-types', '~> 1.5'

# Networking
gem 'http', '~> 5.0'

# Database
gem 'hirb', '~> 0'
gem 'hirb-unicode', '~> 0'
gem 'sequel', '~> 5.49'

group :development, :test do
  gem 'sqlite3', '~> 1.4'
end

group :production do
gem 'pg'
end

# Testing
group :test do
  gem 'headless', '~> 2.3'
  gem 'minitest', '~> 5.0'
  gem 'minitest-rg', '~> 5.0'
  gem 'simplecov', '~> 0'
  gem 'vcr', '~> 6.0'
  gem 'watir', '~> 7.0'
  gem 'webdrivers', '~> 5.0'
  gem 'webmock', '~> 3.0'
end

group :development do
  gem 'rerun', '~> 0'
end
# Debugging
gem 'pry'

# Code Quality
group :development do
  gem 'flog'
  gem 'reek'
  gem 'rubocop'
end

# CareerJet API Gem
gem 'careerjet-api-client'

# HTTP posts
gem 'httmultiparty'

gem 'curb'
