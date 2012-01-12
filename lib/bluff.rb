require 'active_support'
require 'active_support/inflector'

require 'bluff/version'
require 'bluff/configuration'
require 'bluff/builder'

module Bluff
  extend Bluff::Configuration::ClassMethods
  extend Bluff::Builder::ClassMethods
end

require 'bluff/bluffs/data_bluffs'
