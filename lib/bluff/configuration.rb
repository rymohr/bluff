module Bluff
  module Configuration    
    class Base
      attr_accessor :max_attempts
    
      def initialize
        # since we're faking the data but using real objects, there may be times where
        # an object fails to validate due to duplicates etc. Bluff will retry up to
        # max_attempts times before calling it quits
        @max_attempts = 10
      end
    end
  
    module ClassMethods
      def config
        @config ||= Configuration::Base.new
      end
    end
  end
end