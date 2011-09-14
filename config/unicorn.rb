worker_processes 2

working_directory '/home/mmdb/MMDb/current'

listen '/home/mmdb/MMDb/shared/sockets/unicorn.sock', :backlog => 128
listen 8080, :tcp_nopush => true

timeout 60

pid '/home/mmdb/MMDb/shared/pids/unicorn.pid'

stderr_path '/home/mmdb/MMDb/shared/log/unicorn.log'
stdout_path '/home/mmdb/MMDb/shared/log/unicorn.log'

preload_app true

before_fork do |server, worker|
  ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill('QUIT', File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
  Rails.cache.instance_variable_get(:@data).reset
end
