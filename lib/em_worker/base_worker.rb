module EmWorker
  class BaseWorker
    include Base
    attr_accessor :server_ip,:server_port
    attr_accessor :heartbeat_received
    def self.start_worker server_ip,server_port
      EventMachine.run {
        EventMachine.connect(server_ip,server_port,self) do |conn|
          conn.server_ip = server_ip
          conn.server_port = server_port
        end
      }
    end

    def initialize *args
      @worker_options = nil
      @heartbeat_received = false
      @connection_status = false
    end

    def connection_completed
      @bin_parser = BinParser.new
      @connection_status = true
    end

    def receive_data raw_data
      @bin_parser.extract(raw_data) do |complete_message|
        ruby_data = load_data(complete_message)
        heartbeat_received ? new_request(ruby_data) : get_options(ruby_data)
      end
    end

    def new_request ruby_data
    end

    def get_options ruby_data
      @worker_options = ruby_data
      heartbeat_received = true
      worker_init
    end

    def unbind
      @worker_options = {}
      @heartbeat_received = false
      @connection_status = false
    end
  end
end
