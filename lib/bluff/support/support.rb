# Here's how fabricator is autoloading fabrications
#
# def find_definitions
#   path_prefix = defined?(Rails) ? Rails.root : "."
#   Fabrication::Config.fabricator_dir.each do |folder|
#     Dir.glob(File.join(path_prefix, folder, '**', '*fabricator.rb')).sort.each do |file|
#       load file
#     end
#   end
# end

module Bluff
  module Support
    # autoload
  end
end