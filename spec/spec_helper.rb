SPEC_ROOT = File.expand_path(File.dirname(__FILE__)) # ENV["RAILS_ENV"] ||= 'test'
# 
# require_relative '../../config/environment'
# require 'rspec/rails'

require_relative '../lib/bluff.rb'
require_relative 'support/bluffable_class.rb'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
%w(support bluffs).each do |dir|
  Dir[File.join(SPEC_ROOT, dir, '**', '*.rb')].each {|f| require f}
end

RSpec.configure do |config|
  config.mock_with :rspec
end