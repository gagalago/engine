timeout 180
listen "0.0.0.0:3000"

pid "/tmp/unicorn.pid"

worker_processes 5
logger Logger.new($stdout)
