require 'yaml'

PASSWORD = YAML.load_file(Rails.root.join 'config', 'password.yml')['password']

CONFIRM = 'Are you sure?'

STARTUP_TIMESTAMP = Time.now.localtime unless Rails.env.production?

S3_CREDENTIALS = Rails.root.join 'config', 's3.yml'

S3_HEADERS = {
  'Expires' => 20.years.from_now.httpdate,
  'Cache-Control' => 'max-age=315360000, public'
}

S3_HOST_ALIAS = ':cdn.wuj818.com'

S3_URL = Rails.env.production? ? ':s3_alias_url' : ':s3_path_url'
