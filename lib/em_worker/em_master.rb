module EmWorker
  class EmMaster < EventMachine::Connection
    include Base

    # workers who were forked off, but they are yet to send a helo message
    @@forked_workers = {}

    # workers who were forked off, but whose connection is in known state
    @@live_workers = {}
    iattr_accessor :server_ip,:server_port
    attr_accessor :log


    def self.start_master_process
      EventMachine.run {
        EM.start_server("localhost",9000,self)
      }
    end

    def start_worker options = {}
      worker_name = options[:worker].to_s
      worker_name_key = gen_worker_key(worker_name,options[:worker_key])
      return if @@forked_workers[worker_name_key]
      @@forked_workers[worker_name_key] = OpenStruct.new(:options => options)
      fork_and_load(options)
    end

    def fork_and_load options = {}
      if(!fork)
        #[STDOUT,STDIN,STDERR].each { |x| x.reopen(@@log_file) }
        cmd_string = prepare_cmd_line(options)
        p cmd_string
        exec(cmd_string)
      end
    end

    def prepare_cmd_line options
      cmd_string = "em_runner #{options[:worker]}"
      cmd_string << ":#{server_ip}:#{server_port}"
      cmd_string << ":#{WORKER_ROOT}" if defined? WORKER_ROOT
      cmd_string << ":#{WORKER_LOAD_ENV}" if defined? WORKER_LOAD_ENV
      cmd_string
    end

    def write_to_worker worker_uuid,data
      t = object_dump(data)
      @@live_workers[worker_uuid].connection.send_data(t)
    end

    def write_to_client data
      t = object_dump(data)
      p t
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

    def start_worker_request ruby_data
      start_worker(ruby_data)
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
