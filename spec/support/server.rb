module SpecHelpers
  def kirkup(path)
    @server.stop if @server

    @server = Kirk::Server.build(path.to_s)
    @server.start
  end

  def start(app = nil, &blk)
    @server.stop if @server

    if app.respond_to?(:call)

      @server = Kirk::Server.start(app)

    else

      blk ||= proc do
        rack app do
          env :BUNDLE_BIN_PATH => nil, :BUNDLE_GEMFILE => nil
        end
      end

      @server = Kirk::Server.build(nil, &blk)
      @server.start

    end
  end

  def redeploy(path)
    msgs = []
    Kirk::Server::RedeployClient.redeploy(
      '/tmp/kirk.sock', path) { |l| msgs << l }
    msgs
  end
end
