source 'http://rubygems.org'
source 'http://gemcutter.org'

gem 'rails', '3.0.5'
gem 'sqlite3-ruby', :require => 'sqlite3'

gem 'haml'
gem 'haml-rails'
gem 'jquery-rails'
gem 'smurf'

gem 'faker'
gem 'escape_utils'
gem 'kaminari'
gem 'acts-as-taggable-on'
gem 'mechanize'
gem 'paperclip'
gem 'aws-s3'
gem 'memcache-client'

group :development do
  gem 'mongrel', '>= 1.2.0.pre2'
  gem 'rails3-generators'
  gem 'capistrano'

  gem 'wirble'
  gem 'hirb'
  gem 'rainbow'
  gem 'progressbar'
  gem 'bullet'
end

group :test, :development do
  gem 'rspec-rails', '>= 2.0.0'
end

group :test do
  gem 'database_cleaner'
  gem 'rspec', '>= 2.0.0'
  gem 'spork', '>= 0.9.0.rc2'
  gem 'launchy'
  gem 'machinist', '>= 2.0.0.beta1'
  gem 'capybara'
end

group :production do
  gem 'unicorn'
end
