module Bluff
  module Support
    module Persistence
      class Base
        @@adapters = []
    
        class << self
          def register(adapter)
            @@adapters << adapter
          end
      
          def persist(record, options = {})
            adapters = @@adapters.select {|adapter| adapter.persists?(record)}
        
            if adapters.empty?
              raise "#{options[:as] || record.class} is not persistable (#{record})"
            else
              # should first try to persist new associations
              adapters.first.persist(record)
            end
          end
        end
      end
    end
    
    # just looks a little cleaner in use
    def self.persist(record, options = {})
      Persistence::Base.persist(record, options)
    end
  end
end