RSpec::Matchers.define :bluff_for do |expected|
  match do
    begin
      Bluff.send(expected)
    rescue
      false
    end
  end
end