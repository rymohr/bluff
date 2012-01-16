module ActiveRecord
  class Base
  end
end

module Bluff::Support::Persistence
  class ActiveRecordAdapter
    class << self
      def persists?(record)
        record.is_a?(ActiveRecord::Base)
      end

      def persist(record)
        ActiveRecord::Base.transaction do
          record.class.reflect_on_all_associations(:belongs_to).each do |reflection|
            association = record.send(reflection.name)
            association.save! if association && association.new_record?
          end

          record.save!
        end
      end
    end

    Bluff::Support::Persistence::Base.register(self)
  end
end
