module EmWorker
  class EmMaster < EventMachine::Connection
    include Base
    @@live_workers = {}
    @@worker_signatures = {}
    attr_accessor :log


    def self.start_master_process
      EventMachine.run {
        EM.start_server("localhost",9000,self)
      }
    end

    def start_worker options = {}
      worker_name = options[:worker].to_s
      worker_name_key = gen_worker_key(worker_name,options[:worker_key])
      return if @@worker_signatures[worker_name_key]
      @@live_workers[worker_name_key] = options
      fork_and_load(options)
    end

    def fork_and_load options = {}
      if(!fork)
        [STDOUT,STDIN,STDERR].each { |x| x.reopen(@@log_file) }
        exec(prepare_cmd_line(options))
      end
    end

    def prepare_cmd_line options
      cmd_string = "em_runner #{options[:worker]}"
      cmd_string << ":#{server_ip}:#{server_port}"
      cmd_string << ":#{WORKER_ROOT}" if defined? WORKER_ROOT
      cmd_string << ":#{WORKER_LOAD_ENV}" if defined? WORKER_LOAD_ENV
      cmd
    end

    def write_to_worker worker_uuid,data
      t = object_dump(data)
      @@worker_signatures[worker_uuid].connection.send_data(t)
    end

    def write_to_client data
      t = object_dump(data)
      send_data(t)
    end

    def process_worker_hello helo_msg
      worker_name = helo_msg[:worker_name]
      worker_key = helo_msg[:worker_key]
      worker_uuid = gen_worker_key(worker_name,worker_key)
      @@worker_signatures[self.signature] =
        OpenStruct(:worker_name => worker_name,:worker_key => worker_key,:connection => self)
      write_to_client(@@live_workers[worker_uuid].options)
    end

    def receive_data raw_data
      @bin_parser.extract(raw_data) do |complete_message|
        ruby_data = load_data(complete_message)
        dispatch(ruby_data)
      end
    end

    def dispatch ruby_data
      case ruby_data[:type]
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

    # called when connection gets completed
    def post_init
      @bin_parser = BinParser.new
      @log = Log.new
    end

    def unbind

    end
  end
end
