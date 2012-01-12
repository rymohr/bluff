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
    
    context 'with an existing class' do
      class BluffedClass
      end
      
      Bluff.for(:bluffed_class) { true }
      
      specify { BluffedClass.should be_bluffable }
      specify { BluffedClass.should be_bluffable! }
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
