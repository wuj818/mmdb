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

    config.active_record.observers = Dir.glob(Rails.root.join('app', 'observers', '*.rb')).map { |file_path| File.basename(file_path, '.rb') }

    config.paperclip_defaults = {
      storage: 's3',
      s3_host_name: 's3-us-east-2.amazonaws.com',
      s3_region: 'us-east-2',
      s3_headers: {
        'Expires' => 20.years.from_now.httpdate,
        'Cache-Control' => 'max-age=315360000, public'
      },
      s3_credentials: Rails.root.join('config', 'aws.yml'),
      bucket: Rails.application.credentials.s3_bucket[Rails.env.to_sym]
    }
  end
end
