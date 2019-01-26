# frozen_string_literal: true

require_relative "context/version"
require_relative "context/thread_aware"

module Context
  class << self
    def configure
      Context::ThreadAware.new
    end
  end
end
