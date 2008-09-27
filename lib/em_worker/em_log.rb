module EmWorker
  class Log
    extend Forwardable
    class << STDOUT
      def method_missing method_id,*args
        case method_id
        when :info: puts("INFO #{Time.now} : #{args[0]}")
        when :error: puts("ERROR #{Time.now} : #{args[0]}")
        when :debug: puts("DEBUG #{Time.now} : #{args[0]}")
        when :warn: puts("WARN #{Time.now} : #{args[0]}")
        when :fatal: puts("FATAL #{Time.now} : #{args[0]}")
        end
      end
    end

    def initialize logger = nil
      @output_stream = logger || STDOUT
    end
    def_delegators :@output_stream,:info,:error,:fatal,:warn,:debug
  end
end
