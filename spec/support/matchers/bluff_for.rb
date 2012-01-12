RSpec::Matchers.define :bluff_for do |bluff_target|
  match do
    begin
      Bluff.send(bluff_target)
    rescue
      false
    end
  end
end