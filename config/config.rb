# A Sample config file which will be used

EmWorker::Config.config {
  # esp for em_worker server
  server {
    server_host "localhost"
    server_port 9000
    logfile "/home/hemant/em_worker/log/foo.log"
    worker_root "/home/hemant/em_worker/workers"
    autoload_workers [:sample_worker,:foo_worker]
  }

  # for worker specific things
  worker {
    boot File.join(File.dirname(__FILE__),"..","config","environment")
  }

  # for client specific things
  client {
    servers "localhost:9000"
  }
}
