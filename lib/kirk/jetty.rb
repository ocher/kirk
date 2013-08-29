# Only require jars if in the "master" process
unless Kirk.sub_process?
  require "kirk/jetty/servlet-api-2.5"

  require 'kirk/jetty/log4j-1.2.14.jar'
  require 'kirk/jetty/slf4j-api-1.6.1.jar'
  require 'kirk/jetty/slf4j-log4j12-1.6.1.jar'

  %w(util http io continuation server client).each do |mod|
    require "kirk/jetty/jetty-#{mod}-7.6.7.v20120910"
  end
end

module Kirk
  module Jetty
    # Gimme Jetty
    java_import "org.eclipse.jetty.client.HttpClient"
    java_import "org.eclipse.jetty.client.HttpExchange"
    java_import "org.eclipse.jetty.client.ContentExchange"

    java_import "org.eclipse.jetty.io.ByteArrayBuffer"

    java_import "org.eclipse.jetty.server.nio.SelectChannelConnector"
    java_import "org.eclipse.jetty.server.handler.AbstractHandler"
    java_import "org.eclipse.jetty.server.handler.ContextHandler"
    java_import "org.eclipse.jetty.server.handler.ContextHandlerCollection"
    java_import "org.eclipse.jetty.server.Server"

    java_import "org.eclipse.jetty.util.component.LifeCycle"
  end
end
