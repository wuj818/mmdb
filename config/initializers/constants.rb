require 'yaml'

CONFIRM = 'Are you sure?'

STARTUP_TIMESTAMP = Time.now.localtime unless Rails.env.production?

S3_CREDENTIALS = Rails.root.join 'config', 's3.yml'

S3_HEADERS = {
  'Expires' => 20.years.from_now.httpdate,
  'Cache-Control' => 'max-age=315360000, public'
}
