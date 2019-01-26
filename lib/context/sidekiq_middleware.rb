# frozen_string_literal: true

module Context
  class SidekiqMiddleware
    def call(*)
      yield
    ensure
      ThreadAware.reset!
    end
  end
end
