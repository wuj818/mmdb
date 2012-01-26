require 'yaml'

password_file = Rails.env.production? ? '/home/mmdb/MMDb/config/password.yml' : "#{Rails.root}/config/password.yml"

PASSWORD = YAML.load_file(password_file)['password']

CONFIRM = 'Are you sure?'

STARTUP_TIMESTAMP = Time.now.localtime unless Rails.env.production?
