RSpec::Matchers.define :be_bluffable do |expected|
  match do |source|
    begin
      source.bluff
    rescue
      false
    end
  end
end

RSpec::Matchers.define :be_bluffable! do |expected|
  match do |source|
    begin
      source.bluff!
    rescue
      false
    end
  end
end