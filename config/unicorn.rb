# set path to application
app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}/"
working_directory app_dir

# Set unicorn options
worker_processes 2
preload_app true
timeout 30

# Set up socket location
listen "#{shared_dir}/sockets/unicorn.sock", :backlog => 64

# Logging
stderr_path "/var/log/govreposearch/unicorn.stderr.log"
stdout_path "/var/log/govreposearch/unicorn.stdout.log"

# Set master PID location
pid "#{shared_dir}/pids/unicorn.pid"

before_fork do |server, worker|
  # Attempt to open and hold a file open, locked in read only mode. This file
  # will remain locked so long as the master or children are running which
  # allows upstart to detect when the process exits.
  f = File.open("#{server.config[:pid]}.lock", 'w')
  exit unless f.flock(File::LOCK_SH)
end
