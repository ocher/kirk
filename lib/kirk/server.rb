require 'kirk'

module Kirk
  class Server
    autoload :ApplicationConfig,  'kirk/server/application_config'
    autoload :Builder,            'kirk/server/builder'
    autoload :DeployWatcher,      'kirk/server/deploy_watcher'
    autoload :Handler,            'kirk/server/handler'
    autoload :HotDeployable,      'kirk/server/hot_deployable'
    autoload :InputStream,        'kirk/server/input_stream'
    autoload :RedeployClient,     'kirk/server/redeploy_client'

    def self.build(file = nil, &blk)
      root    = File.dirname(file) if file
      builder = Builder.new(root)

      if file && !File.exist?(file)
        raise MissingConfigFile, "config file `#{file}` does not exist"
      end

      file ? builder.instance_eval(File.read(file), file) :
             builder.instance_eval(&blk)

      options              = builder.options
      options[:connectors] = builder.to_connectors

      new(builder.to_handler, options)
    end

    def self.start(handler, options = {})
      new(handler, options).tap do |server|
        server.start
      end
    end

    def initialize(handler, options = {})
      if Jetty::AbstractHandler === handler
        @handler = handler
      elsif handler.respond_to?(:call)
        @handler = Handler.new(handler)
      else
        raise "#{handler.inspect} is not a valid Rack application"
      end

      @options = options
    end

    def start
      watcher.start if watcher

      @server = Jetty::Server.new.tap do |server|
        connectors.each do |conn|
          server.add_connector(conn)
        end

        server.set_handler(@handler)
      end

      @server.start
    end

    def join
      @server.join
    end

    def stop
      watcher.stop if watcher
      @server.stop
    end

  private

    def connectors
      @options[:connectors] ||=
        [ Jetty::SelectChannelConnector.new.tap do |conn|
          host = @options[:host] || '0.0.0.0'
          port = @options[:port] || 9090

          conn.set_host(host)
          conn.set_port(port.to_i)
        end ]
    end

    def watcher
      @options[:watcher]
    end
  end
end
