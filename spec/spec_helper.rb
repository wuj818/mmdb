require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'database_cleaner'

  Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

  RSpec.configure do |config|
    Capybara.save_and_open_page_path = "#{Rails.root}/tmp/capybara"
    ActiveSupport::Dependencies.clear

    Machinist.configure do |config|
      config.cache_objects = false
    end

    config.mock_with :rspec
    config.use_transactional_fixtures = false

    config.before(:suite) do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with :truncation
    end

    config.before(:each) do
      if example.metadata[:js]
        Capybara.current_driver = :selenium
        DatabaseCleaner.strategy = :truncation
      end
      Capybara.reset_sessions!
      DatabaseCleaner.start
    end

    config.after(:each) do
      if example.metadata[:js]
        Capybara.use_default_driver
        DatabaseCleaner.strategy = :transaction
      end
      DatabaseCleaner.clean
    end

    def test_login
      controller.login_admin
    end
  end
end

Spork.each_run do
end
