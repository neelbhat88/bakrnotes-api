workers (ENV["WEB_CONCURRENCY"] || 2).to_i
threads_count = (ENV["THREAD_COUNT"] || 5).to_i
threads threads_count, threads_count

environment ENV["RACK_ENV"] || "development"

# Use the `preload_app!` method when specifying a `workers` number.
# This directive tells Puma to first boot the application and load code
# before forking the application. This takes advantage of Copy On Write
# process behavior so workers use less memory. If you use this option
# you need to make sure to reconnect any threads in the `on_worker_boot`
# block.
#
preload_app!

# Because we are using preload_app, an instance of our app is created by master process (calling our initializers)
# and then memory space
# is forked. So we should close DB connection in the master process to avoid connection leaks.
# https://github.com/puma/puma/issues/303
# http://stackoverflow.com/questions/17903689/puma-cluster-configuration-on-heroku
# http://www.rubydoc.info/gems/puma/2.14.0/Puma%2FDSL%3Abefore_fork
# Dont have to worry about Sidekiq's connection to Redis because connections are only created when needed. As long as
# we are not
# queuing workers when rails is booting, there will be no redis connections to disconnect, so it should be fine.
before_fork do
  # puts "Puma master process about to fork. Closing existing Active record connections."
  # ActiveRecord::Base.connection.disconnect!
end

# The code in the `on_worker_boot` will be called if you are using
# clustered mode by specifying a number of `workers`. After each worker
# process is booted this block will be run, if you are using `preload_app!`
# option you will want to use this block to reconnect to any threads
# or connections that may have been created at application boot, Ruby
# cannot share connections between processes.
#
on_worker_boot do
  # ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end
