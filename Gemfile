source "https://rubygems.org"

ruby "3.1.7"

# Rails Framework
gem "rails", "~> 7.1.3"

# Database
gem "pg", "~> 1.1"

# Web Server
gem "puma", ">= 5.0"

# Frontend
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"

# Authentication
gem "devise", "~> 4.9"

# Background Jobs
gem "sidekiq", "~> 7.2"

# HTTP Client for AI Integration
gem "faraday", "~> 2.9"
gem "faraday-multipart"

# Image Processing (for Receipt OCR)
gem "mini_magick", "~> 4.12"

# Environment Variables
gem "dotenv-rails", groups: [:development, :test]

# Reduces boot times through caching
gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[mri windows]
  gem "rspec-rails", "~> 6.1"
  gem "factory_bot_rails"
  gem "faker"
end

group :development do
  gem "web-console"
end

group :test do
  gem "shoulda-matchers", "~> 6.0"
  gem "simplecov", require: false
end