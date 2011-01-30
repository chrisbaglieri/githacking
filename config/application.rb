require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module Githacking
  class Application < Rails::Application
    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
    
    config.github = {}
    config.github[:client_id] = '18786efa22cdf1194680'
    config.github[:secret] = '5854dbf3ddb941f1ea5b2d112f958c3b83737863'
    config.github[:redirect_uri] = 'http://githacking.com:3000/users/oauth'
      
    config.generators do |g|
      g.test_framework      :rspec
      g.fixture_replacement :factory_girl
      g.template_engine     :haml
    end
  end
end
