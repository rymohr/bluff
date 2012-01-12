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
    
    context 'when given additional arguments' do
      it 'passes the arguments for use in the bluff' do
        Bluff.for(:foo) {|attributes| attributes[:value]}
        Bluff.foo({:value => 'override'}).should eq('override')
      end
    end
    
    it 'executes within the DSL context' do
      Bluff.for(:foo) { self.class.should == Bluff::Builder::Definition } # matchers not defined on self ??
      Bluff.foo
    end
    
    describe 'block' do
      # context 'when an argument is required' do
      #   Bluff.for(:foo) {|value| value}
      #   
      #   describe 'calling the bluff without an argument should raise an error' do
      #     Bluff.foo
      #     # lambda{ Bluff.foo }.should raise_error
      #   end
      #   
      #   describe 'calling the bluff with an argument should pass the argument to the block' do
      #     Bluff.foo(99).should eq(99)
      #   end
      # end
      
      describe 'DSL' do
        describe '.insist' do
          it 'raises an error if the insisted attribute is missing' do
            Bluff.for(:foo) {|attributes| insist(:bar) }
            lambda{ Bluff.foo }.should raise_error(ArgumentError, /bar cannot be bluffed for foo/)
          end
        
          it 'does nothing if the attribute is present' do
            Bluff.for(:foo) {|attributes| insist(:bar) }
            lambda{ Bluff.foo({:bar => :red}) }.should_not raise_error
          end
        
          it 'checks for the foreign key if the association is missing' do
            Bluff.for(:foo) {|attributes| insist(:bar) }
            lambda{ Bluff.foo({:bar_id => :red}) }.should_not raise_error
          end
        end

        # attributes.requires(:).defaults(:)
        
        # default is not ready yet
        # describe '.default' do
        #   it 'assigns the given value to the attributes hash if blank' do
        #     Bluff.for(:foo) {|attributes={}|
        #       attributes.must_provide(:bar)
        #       
        #       attributes.with_defaults({
        #         :bar => :red
        #       })
        #       
        #       attributes.default(:bar, :red)
        #       attributes[:bar]
        #     }
        #     
        #     Bluff.foo.should eq(:red)
        #     Bluff.foo({:bar => ''}).should eq(:red)
        #     Bluff.foo({:bar => :blue}).should eq(:blue)
        #   end
        # end
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
