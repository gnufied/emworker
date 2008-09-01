# A Sample config file which will be used

EmWorker::Config.config {
  server {
    server_host "localhost"
    server_port 9000
    logfile "/home/hemant/em_worker/log/foo.log"
    worker_root "/home/hemant/em_worker/workers"
  }
  worker {
    boot File.join(File.dirname(__FILE__),"..","config","environment")
  }
}
