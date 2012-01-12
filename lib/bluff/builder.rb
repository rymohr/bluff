require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/array/wrap'
require 'active_support/core_ext/array/conversions'
require 'active_support/core_ext/hash/indifferent_access'

require 'bluff/support/backend'
require 'bluff/support/backend/active_record'

module Bluff
  module Builder
    class Definition
      def initialize(target, attributes = {})
        @target = target
        @attributes = attributes
        
        if @attributes.is_a?(Hash)
          @attributes = @attributes.with_indifferent_access
        else
          raise ArgumentError, 'Bluff argument must be a single hash'
        end
      end
      
      def attributes
        @attributes
      end
      
      def attributes=(hash)
        @attributes = hash
      end
      
      # can use whatever fits the situation
      alias :params :attributes
      alias :params= :attributes=
      
      def execute(&block)
        self.instance_exec(@attributes, &block)
      end
      
      def requires(attributes)
        missing = []
        
        Array.wrap(attributes).each do |attribute|
          missing << attribute unless provided?(attribute)
        end
        
        raise ArgumentError, "#{missing.to_sentence} cannot be bluffed for #{@target}" unless missing.empty?
      end
      
      def default(attribute, value)
        @attributes[attribute] = value if @attributes[attribute].blank?
      end
      
      def defaults(hash)
        hash.each {|key, value| default(key, value)}
      end
      
      private
      # returns true if attributes contains attribute or attribute_id
      def provided?(attribute)
        @attributes.is_a?(Hash) && !(@attributes[attribute].blank? && @attributes["#{attribute}_id"].blank?)
      end
    end
    
    module ClassMethods
      # bluffs for all!
      # Object.define_singleton_method :bluff do puts 'bluff on class'; end # defines class method
      # Object.send :define_method, :bluff do puts 'bluff on instance'; end # defines instance method
      # can pass lambda
      
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
        define_singleton_method(field) do |*arguments|
          bluffed_object = nil
      
          config.max_attempts.times do
            bluffed_object = Definition.new(field, *arguments).execute(&block) #DSL.instance_exec(*args, &block)
            break if !bluffed_object.respond_to?(:valid?) || bluffed_object.valid?
          end
      
          bluffed_object
        end
      end
  
      def define_bluff_bang(field)
        define_singleton_method "#{field}!" do |*arguments|
          send(field, *arguments).tap do |record|
            Bluff::Support::Backend.save!(record, field)
          end
        end
      end
      
      def extend_target(field, options)
        class_name = options[:class_name] || field.to_s.camelize
        
        # need to find a way to autoload existing classes that haven't been loaded yet
        begin
          klass = class_name.constantize
        rescue NameError
          # alright if it doesn't exist
        end
        
        if klass        
          # just forward the calls back to Bluff
          bluff = lambda {|*args| Bluff.send(field, *args)}
          bluff_bang = lambda {|*args| Bluff.send("#{field}!", *args)}
          
          klass.singleton_class.instance_eval do
            # define_method(:bluff) {|*args| dsl.instance_exec(*args, &bluff) }
            # define_method(:bluff!) {|*args| dsl.instance_exec(*args, &bluff_bang) } if options[:bang]
            # 
            define_method(:bluff) {|*args| bluff.call(*args) }
            define_method(:bluff!) {|*args| bluff_bang.call(*args) } if options[:bang]
          end
            
          # puts "def bluff(*args); Bluff.send(:#{field}, *args); end"
          # klass.instance_eval { "def bluff(*args); Bluff.send(:#{field}, *args); end" }
          # 
          # .instance_eval { "def bluff(*args); Bluff.send(:account, *args); end" }
          # klass.define_singleton_method :bluff do |*args|
          #             Bluff.send(field, *args)
          #           end
          
          #puts "bluff method is #{klass.bluff}"

          # if options[:bang]
          #   klass.define_singleton_method :bluff! do |*args|
          #     Bluff.send("#{field}!", *args)
          #   end
          #   
          #   #puts "bluff bang method is #{klass.bluff!}"
          # end
        else
          # not a big deal. bluff might be data instead of a model.
          # puts "Bluff class not found: #{class_name}"
        end
      end
    end
  end
end