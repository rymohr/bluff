module ActiveRecord
  class Base
  end
end

module Bluff::Support::ActiveRecord
  class Backend
    class << self
      def accepts?(record)
        puts "checking #{record} as #{record.class}, if #{ActiveRecord::Base}"
        record.is_a?(ActiveRecord::Base)
      end

      def save!(record)
        ActiveRecord::Base.transaction do
          record.class.reflect_on_all_associations(:belongs_to).each do |reflection|
            association = record.send(reflection.name)
            association.save! if association && association.new_record?
          end

          record.save!
        end
      end
    end

    Bluff::Support::Backend.register(self)
  end
end
