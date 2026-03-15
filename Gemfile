# frozen_string_literal: true

source "https://rubygems.org"

ruby "~> 3.3.0"

gem "rails", "~> 7.2"
gem "pg", "~> 1.5"
gem "puma", "~> 6.4"
gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[windows jruby]

# Performance benchmarking
gem "benchmark-ips", "~> 2.13"
gem "memory_profiler", "~> 1.0"

# Fake data for seeds
gem "faker", "~> 3.2"
gem "activerecord-import", "~> 1.4"

# Code quality
gem "rubocop", "~> 1.60", require: false
gem "rubocop-rails", "~> 2.24", require: false
group :development, :test do
  gem "debug", platforms: %i[mri windows]
  gem "rake", "~> 13.0"
end
