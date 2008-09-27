module EmWorker
  class Runner
    attr_accessor :worker_root,:worker_name,:worker_load_env,:server_ip,:server_port
    def initialize args
      cmd_args = args.split(':')

      @worker_name = cmd_args[0]
      @server_ip = cmd_args[1]
      @server_port = cmd_args[2].to_i
      @worker_root = cmd_args[3]
      @worker_load_env = cmd_args[4]
      require worker_load_env if worker_load_env && !worker_load_env.empty?
      load_worker
    end
    def load_worker
      if worker_root && File.file?("#{worker_root}/#{worker_name}.rb")
        require "#{worker_root}/#{worker_name}"
        worker_klass = Object.const_get(packet_classify(worker_name))
      end
    end
  end
end
