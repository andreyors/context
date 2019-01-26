# frozen_string_literal: true

require "rack/body_proxy"

module Context
  class RackMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      ThreadAware.up!
      response = @app.call(env)

      result = response << Rack::BodyProxy.new(response.pop) { ThreadAware.flush! }
    ensure
      ThreadAware.flush! unless result
    end
  end
end
