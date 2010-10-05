require 'yaml'

PASSWORD = ENV['MMDB_PASSWORD'] || YAML.load_file("#{Rails.root}/config/password.yml")['password']
