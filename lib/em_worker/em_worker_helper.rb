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
    def metaclass; class << self; self; end; end
    def iattr_accessor *args
      metaclass.instance_eval do
        attr_accessor *args
      end
      args.each do |attr|
        class_eval do
          define_method(attr) { self.class.send(attr)}
          define_method("#{attr}=") { |value| self.class.send("#{attr}="),value}
        end
      end
    end
    module_function(:metaclass,:iattr_accessor,:load_data)
  end
end
