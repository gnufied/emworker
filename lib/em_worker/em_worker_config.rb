module EmWorker
  class ServerConfig
    attributes %w(server_host server_port logfile worker_root)
  end

  class WorkerConfig
    attributes %w(boot servers)
  end

  class WorkerConfig
    attr_accessor :server, :worker
    def self.config &block
      t = new
      t.instance_eval &block
    end

    def server &block
      @server = ServerConfig.new
      @server.instance_eval &block
    end

    def worker &block
      @worker = WorkerConfig.new
      @worker.instance_eval &block
    end
  end
end
