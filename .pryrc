require 'bundler/setup'
require 'expedition'

def reload!
  old_verbose, $VERBOSE = $VERBOSE, nil
  Dir["#{File.dirname(__FILE__)}/lib/**/*.rb"].sort.each { |f| load f }
ensure
  $VERBOSE = old_verbose
end

def client(host = 'localhost', port = 4028)
  Expedition.new(host, port)
end
