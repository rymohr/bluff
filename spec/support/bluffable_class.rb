class BluffableClass
  def initialize
    @new_record = true
  end
  
  def save
    @new_record = false
  end
  
  def new_record?
    @new_record
  end
end

module Bluff::Support::Persistence
  class BluffableClassAdapter
    class << self
      def persists?(record)
        record.is_a?(BluffableClass)
      end

      def persist(record)
        record.save
      end
    end
  
    Bluff::Support::Persistence::Base.register(self)
  end
end