# A Sample config file which will be used

EmWorker::Config.config {
  # esp for em_worker server
  server {
    # host and port on which em_worker will be started
    server_host "localhost"
    server_port 9000

    # where are the workers?
    worker_root "/home/hemant/em_worker/workers"

    app_root "/home/hemant/em_worker"

    # which of the workers should be autoloaded
    autoload_workers [:sample_worker,:foo_worker]
    # which environment should be loaded in server
    boot File.join(File.dirname(__FILE__),"..","config","environment")
  }

  # for worker specific things
  worker {
    # this will be loaded in worker and hence can be used to load merb or rails
    # environment in workers
    boot(File.join(File.dirname(__FILE__),"..","config","environment"),
         :except => :foo_worker)

    scheduler_options = {
      :foo_worker => {
        :barbar => { :trigger_args => ""}
      }
    }

    schedules scheduler_options
  }

  # for client specific things
  client {
    servers "localhost:9000"
  }
}
