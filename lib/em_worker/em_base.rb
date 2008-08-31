module EmWorker
  module Base
    def self.included(base_klass)
      base_klass.extend(ClassMethods)
    end
    module ClassMethods
      include Helper
    end
  end
end
