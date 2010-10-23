require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module Mmdb
  class Application < Rails::Application
    config.generators do |g|
      g.template_engine :haml
      g.test_framework :rspec,
        :view_specs       => false,
        :routing_specs    => false,
        :helpers          => false,
        :integration_tool => false
    end

    config.active_record.timestamped_migrations = false
    config.autoload_paths += %W(#{config.root}/lib)
    config.time_zone = 'Eastern Time (US & Canada)'
    config.filter_parameters += [:password]
    config.encoding = "utf-8"
  end
end
