module EmWorker
  class ServerConfig
    attributes %w(server_host server_port logfile worker_root boot autoload_workers app_root)
  end

  class WorkerConfig
    attributes %w(boot servers schedules)
  end

  class ClientConfig
    attributes %w(servers)
  end

  class Config
    attr_accessor :s,:w,:c
    def self.config &block
      Config.const_set(:EM_WORKER_CONFIG,new)
      EM_WORKER_CONFIG.instance_eval &block
    end

    def server &block
      @s = ServerConfig.new
      @s.instance_eval &block
    end

    def worker &block
      @w = WorkerConfig.new
      @w.instance_eval &block
    end
    def client &block
      @c = ClientConfig.new
      @c.instance_eval &block
    end
  end
end
