class LogMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    correlation_id = Rack::Request.new(env).env['HTTP_CID'] || "cid:#{UUID.new.generate}"
    Thread.current[:cid] = correlation_id
    SemanticLogger.tagged(correlation_id) do
      @app.call(env)
    end
  end
end
