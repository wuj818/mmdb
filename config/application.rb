require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Mmdb
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.time_zone = 'Eastern Time (US & Canada)'

    config.autoload_paths << Rails.root.join('lib')

    config.active_record.sqlite3.represent_boolean_as_integer = true

    config.active_record.observers = Dir.glob(Rails.root.join('app', 'observers', '*.rb')).map { |file_path| File.basename(file_path, '.rb') }
  end
end
