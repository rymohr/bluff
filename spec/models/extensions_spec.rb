require 'spec_helper'

describe Bluff do
  describe '.for' do
    context 'with an existing class' do
      Bluff.for(:bluffable_class) { BluffableClass.new }

      specify { BluffableClass.should be_bluffable }
      specify { BluffableClass.should be_bluffable! }
    end
  end
end
