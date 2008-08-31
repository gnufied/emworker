module EmWorker
  class EmMaster
    include Base
    ittr_accessor :live_workers,:worker_signatures
    @live_workers = {}
    @worker_signatures = {}
    attr_accessor :log
    def start_worker options = {}

    end

    def fork_and_load
      if(!fork)
        exec(prepare_cmd_line)
      end
    end

    def prepare_cmd_line *args
      "em_runner #{args.join(":")}"
    end

    def write_to_worker worker_name,data
    end

    def write_to_client data

    end

    def receive_data raw_data
      @bin_parser.extract(raw_data) do |complete_message|
        ruby_data = load_data(complete_message)
        dispatch(ruby_data)
      end
    end

    def dispatch ruby_data
      case ruby_data[:type]
      when :send_options; send_options(ruby_data)
      when :worker_response; receive_worker_response(ruby_data)
      when :async_invoke; async_method_invoke(ruby_data)
      when :get_result; get_result_object(ruby_data)
      when :start_worker; start_worker_request(ruby_data)
      when :delete_worker; delete_worker_request(ruby_data)
      when :worker_info; get_worker_info(ruby_data)
      when :all_worker_info; get_all_worker_info(ruby_data)
      else; log(ruby_data)
      end
    end

    def send_options ruby_data

    end

    # called when connection gets completed
    def post_init
      @bin_parser = BinParser.new
      @log = STDOUT
    end

    def unbind

    end
  end
end
