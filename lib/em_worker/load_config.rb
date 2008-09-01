module EmWorker
  class Config
    def self.config &block
      instance_eval(block)
    end

    def method_missing method_id,*args
      first_arg = args.shift
      self.class.class_eval { attr_accessor method_id }
      instance_variable_set("@#{method_id}",first_arg)
    end
  end
end


