require 'yaml'

PASSWORD = YAML.load_file(Rails.root.join 'config', 'password.yml')['password']

CONFIRM = 'Are you sure?'

STARTUP_TIMESTAMP = Time.now.localtime unless Rails.env.production?
