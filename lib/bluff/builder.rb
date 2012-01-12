module Bluff
  module Builder
    module ClassMethods
        # def insist(field)
      #   raise ArgumentError, "#{field} cannot be bluffed for #{target}"
      # end
  
      # options: class_name
      def for(field, options = {}, &block)
        options = {:bang => true}.merge(options)
    
        extend_bluff(field, options, &block)
        extend_target(field, options)
      end
  
      private
      def extend_bluff(field, options, &block)      
        define_bluff(field, &block)
        define_bluff_bang(field) if options[:bang]
      end
  
      def define_bluff(field, &block)
        define_singleton_method(field) do |*args|
          bluffed_object = nil
      
          config.max_attempts.times do
            bluffed_object = block.call(*args)
            break if !bluffed_object.respond_to?(:valid?) || bluffed_object.valid?
            puts "!!!! FAILED BLUFF -- REATTEMPTING"
          end
      
          bluffed_object
        end
      end
  
      def define_bluff_bang(field)
        define_singleton_method "#{field}!" do |*args|
          send(field, *args).tap do |record|
            ActiveRecord::Base.transaction do
              record.class.reflect_on_all_associations(:belongs_to).each do |reflection|
                association = record.send(reflection.name)
                association.save! if association && association.new_record?
              end
          
              record.save!
            end
          end
        end
      end
  
      def extend_target(field, options)
        class_name = options[:class_name] || field.to_s.classify
      
        if Kernel.const_defined?(class_name)
          klass = Kernel.const_get(class_name)
        
          # just forward the calls back to Bluff
          klass.define_singleton_method :bluff do |*args|
            Bluff.send(field, *args)
          end

          if options[:bang]
            klass.define_singleton_method :bluff! do |*args|
              Bluff.send("#{field}!", *args)
            end
          end
        else
          # not a big deal. bluff might be data instead of a model.
          # puts "Bluff class not found: #{class_name}"
        end
      end
    end
  end
end