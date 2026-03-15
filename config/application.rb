# frozen_string_literal: true

require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module RailsPerformanceLab
  class Application < Rails::Application
    config.load_defaults 7.2
    config.api_only = false
  end
end
