if ENV['RAILS_ENV'] == 'production'
  environment 'production'

  workers ENV.fetch('WEB_CONCURRENCY') { 2 }

  threads_count = ENV.fetch('RAILS_MAX_THREADS') { 5 }
  threads threads_count, threads_count

  shared_dir = File.expand_path('..', __dir__)
  log_dir = "#{shared_dir}/log"

  stdout_redirect "#{log_dir}/puma_access.log", "#{log_dir}/puma_error.log", true

  pidfile "#{shared_dir}/tmp/pids/puma.pid"
  state_path "#{shared_dir}/tmp/pids/puma.state"
  bind "unix://#{shared_dir}/tmp/sockets/puma.sock"
  activate_control_app "unix://#{shared_dir}/tmp/sockets/pumactl.sock"
end
