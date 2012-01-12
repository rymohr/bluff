require 'spec_helper'

describe Bluff do
  describe 'via bang!' do
    context 'when the bluffed object is not saveable' do
      it 'throws an error when called' do
        class BluffedClass
        end

        Bluff.for(:bluffed_class) { BluffedClass.new }
        
        lambda{ BluffedClass.bluff! }.should raise_error
      end
    end
    
    context 'when the bluffed object is saveable' do
      it 'returns the bluffed object' do
        class BluffedClass
        end

        Bluff.for(:bluffed_class) { BluffedClass.new }
        
        module Bluff::Support::BluffedClass
          class Backend
            class << self
              def accepts?(record)
                record.is_a?(BluffedClass)
              end

              def save!(record)
                record
              end
            end

            Bluff::Support::Backend.register(self)
          end
        end
        
        lambda{ BluffedClass.bluff! }.should_not raise_error
      end
    end
  end
end
