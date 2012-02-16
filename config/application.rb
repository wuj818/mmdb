require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require *Rails.groups(:assets => %w(development test))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

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

    config.active_record.observers = :countable_observer, :credit_observer, :movie_observer
    config.active_record.timestamped_migrations = false
    config.autoload_paths += %W(#{config.root}/lib)
    config.time_zone = 'Eastern Time (US & Canada)'
    config.filter_parameters += [:password]
    config.encoding = "utf-8"

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.assets.initialize_on_precompile = false
  end
end
