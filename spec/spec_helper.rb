$:.unshift File.expand_path('../../build', __FILE__)
require 'kirk'
require 'fileutils'
require 'openssl'
require 'socket'
require 'zlib'
require 'rack/test'
require 'net/http'

# Add log4j.properties to the classpath
$CLASSPATH << File.expand_path('..', __FILE__)

Dir[File.expand_path('../support/*.rb', __FILE__)].each { |f| require f }

IP_ADDRESS     = IPSocket.getaddress(Socket.gethostname)
ORIGINAL_UMASK = File.umask

# Make logger more verbose.
# java.lang.System.set_property("org.eclipse.jetty.LEVEL", "DEBUG")
# Mute logger
java.lang.System.err.close();

RSpec.configure do |config|
  config.include SpecHelpers
  config.include Rack::Test::Methods

  config.before :each do
    reset!
  end

  config.after :each do
    File.umask(ORIGINAL_UMASK)
    Kirk::Client.stop
    @server.stop if @server
    @server = nil
  end
end
