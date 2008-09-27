module EmWorker
  module Base
    def self.included(base_klass)
      base_klass.extend(ClassMethods)
      base_klass.send(:include,Helper)
    end
    module ClassMethods
      include Helper
    end
  end
end
