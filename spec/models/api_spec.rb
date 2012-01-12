require 'spec_helper'

describe Bluff do
  # define the basic data API
  describe '.for' do
    context 'at the basic level' do
      it 'accepts a target and a block and returns the value of the block' do
        Bluff.for(:foo) { 'bar' }
        Bluff.foo.should eq('bar')
      end
    end
  end
  
  describe '.bluff' do
    it 'returns an unsaved instance of the bluff' do
      Bluff.for(:bluffable_class) { BluffableClass.new }
      Bluff.bluffable_class.new_record?.should be_true
    end
  end
  
  describe '.bluff!' do
    context 'when the bluffed object is not saveable' do
      it 'throws an error when called' do
        class TransientClass
        end
        
        Bluff.for(:transient_class) { TransientClass.new }
        lambda{ Bluff.transient_class! }.should raise_error(RuntimeError, /cannot be bang bluffed/)
      end
    end
    
    context 'when the bluffed object is saveable' do
      it 'returns the bluffed object' do
        Bluff.for(:bluffable_class) { BluffableClass.new }
        Bluff.bluffable_class!.new_record?.should be_false
      end
    end
  end
  
  describe 'data' do    
    context 'when requesting a defined data bluff' do
      bluffs = [
        #
        # alright to add to these but DO NOT REMOVE them without 
        # good reason and without bumping the major version
        #
        
        # people
        :name,
        :username,
        :email,
        
        # companies
        :company_name,
        
        # words
        :words,
        :phrase
      ]
    
      bluffs.each do |target|
        specify { should bluff_for(target) }
      end
    end
  
    context 'when requesting an undefined data bluff' do
      it 'should raise an exception' do
        lambda{ Bluff.missing }.should raise_error
      end
    end
  end
end
