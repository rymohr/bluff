module Bluff::Support
  class Backend
    @@handlers = []
    
    class << self
      def register(handler)
        @@handlers << handler
      end
      
      def save!(record, name)
        handlers = @@handlers.select {|handler| handler.accepts?(record)}
        
        if handlers.empty?
          raise "#{name} cannot be bang bluffed (#{record})"
        else
          handlers.first.save!(record)
        end
      end
    end
  end
end