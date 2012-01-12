RSpec::Matchers.define :bluff_instance_of do |expected|
  match do |actual|
    actual.should be_an_instance_of(ActiveRecord::Relation)
  end
end