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

module Bluff::Support::BluffableClass
  class Backend
    class << self
      def accepts?(record)
        record.is_a?(BluffableClass)
      end

      def save!(record)
        record.save
      end
    end

    Bluff::Support::Backend.register(self)
  end
end