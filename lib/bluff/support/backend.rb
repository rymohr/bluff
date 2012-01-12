module Bluff::Support
  class Backend
    @@handlers = []
    
    class << self
      def register(handler)
        @@handlers << handler
      end
      
      def save!(record)
        handlers = @@handlers.select {|handler| handler.accepts?(record)}
        
        if handlers.empty?
          raise 'Record cannot be saved'
        else
          handlers.first.save!(record)
        end
      end
    end
  end
end