module EmWorker
  class EmMaster < EventMachine::Connection
    include Base

    # workers who were forked off, but they are yet to send a helo message
    @@forked_workers = {}

    # workers who were forked off, but whose connection is in known state
    @@live_workers = {}
    @@workers_loaded = false
    iattr_accessor :server_ip,:server_port
    attr_accessor :log


    def self.start_master_process
      EventMachine.run {
        EM.start_server(config.s.server_host,config.s.server_port,self)
      }
    end

    def load_all_workers
      start_worker(:worker => "sample_worker")
    end

    def start_worker options = {}
      worker_name = options[:worker].to_s
      worker_name_key = gen_worker_key(worker_name,options[:worker_key])
      return if @@forked_workers[worker_name_key]
      @@forked_workers[worker_name_key] = OpenStruct.new(:options => options)
      fork_and_load(options)
    end

    def fork_and_load options = {}
      if(!(pid = fork))
        #[STDOUT,STDIN,STDERR].each { |x| x.reopen(@@log_file) }
        cmd_string = prepare_cmd_line(options)
        exec(cmd_string)
      end
      Process.detach(pid)
    end

    def prepare_cmd_line options
      cmd_string = "./bin/em_runner #{options[:worker]}"
      cmd_string << ":#{server_ip}:#{server_port}"
      worker_root = options[:worker_root] || (defined? WORKER_ROOT) ? WORKER_ROOT : nil
      cmd_string << ":#{worker_root}" if worker_root && !worker_root.empty?
      worker_env = options[:worker_env] || (defined? WORKER_LOAD_ENV) ? WORKER_LOAD_ENV : nil
      cmd_string << ":#{worker_env}" if worker_env && !worker_env.empty?
      cmd_string
    end

    def write_to_worker worker_uuid,data
      t = object_dump(data)
      @@live_workers[worker_uuid].connection.send_data(t)
    end

    def write_to_client data
      t = object_dump(data)
      send_data(t)
    end

    def process_worker_hello helo_msg
      worker_name = helo_msg[:worker]
      worker_key = helo_msg[:worker_key]
      worker_uuid = gen_worker_key(worker_name,worker_key)
      @@live_workers[self.signature] =
        OpenStruct.new(:worker => worker_name,:worker_key => worker_key,:connection => self,:worker_uuid => worker_uuid)
      write_to_client(@@forked_workers[worker_uuid].options)
    end

    def receive_data raw_data
      @bin_parser.extract(raw_data) do |complete_message|
        ruby_data = load_data(complete_message)
        dispatch(ruby_data)
      end
    end

    def dispatch ruby_data
      request_type = ruby_data[:type]
      begin
        ruby_data.delete(:type)
      rescue
        log.info(ruby_data)
        return
      end

      case request_type
      when :worker_hello; process_worker_hello(ruby_data)
      when :worker_response; receive_worker_response(ruby_data)
      when :async_invoke; async_method_invoke(ruby_data)
      when :get_result; get_result_object(ruby_data)
      when :start_worker; start_worker_request(ruby_data)
      when :delete_worker; delete_worker_request(ruby_data)
      when :worker_info; get_worker_info(ruby_data)
      when :all_worker_info; get_all_worker_info(ruby_data)
      else; log.info(ruby_data)
      end
    end

    def start_worker_request ruby_data
      start_worker(ruby_data)
    end

    # called when connection gets completed
    def post_init
      load_all_workers unless @@workers_loaded
      @bin_parser = BinParser.new
      @log = Log.new
    end

    def unbind

    end
  end
end
