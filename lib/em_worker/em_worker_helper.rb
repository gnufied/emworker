module EmWorker
  module Helper
    def load_data data
      begin
        return Marshal.load(data)
      rescue
        error_msg = $!.message
        if error_msg =~ /^undefined\ .+\ ([A-Z].+)/
          file_name = $1.underscore
          begin
            require file_name
            return Marshal.load(data)
          rescue
            return nil
          end
        else
          return nil
        end
      end # end of load_data method
    end

    def gen_worker_key worker_name,worker_key
      [worker_name,worker_key].compact.join("^")
    end

    def object_dump p_data
      object_dump = Marshal.dump(p_data)
      dump_length = object_dump.length.to_s
      length_str = dump_length.rjust(9,'0')
      final_data = length_str + object_dump
    end

    def metaclass; class << self; self; end; end

    def iattr_accessor *args
      args.each do |a|
        metaclass.instance_eval do
          define_method("#{a}=") { |value|
            @a = value
          }
          define_method(a) do |*values|
            return @a if values.empty?
            @a = values.first
          end
        end
        class_eval do
          define_method(a) { self.class.send(a)}
          define_method("#{a}=") { |value| self.class.send(a,value) }
        end
      end
    end

    def em_worker_classify original_string
      original_string.split('_').map {|x| x.capitalize}.join
    end

    def config; Config::EM_WORKER_CONFIG; end

    def compact(options = { })
      options.delete_if { |key,value| value.nil? }
      options
    end

    def self.load_config
      return if defined?(Config::EM_WORKER_CONFIG)
      require "#{EM_WORKER_ROOT}/config/config.rb"
    end
    load_config
  end
end
