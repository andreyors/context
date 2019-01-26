# frozen_string_literal: true

require "thread"

module Context
  class ThreadAware
    class << self
      def reset!
        Thread.current[:thread_aware] = {}
      end

      def storage
        Thread.current[:thread_aware] ||= {}
      end

      def exist?(key)
        storage.key?(key)
      end

      def read(key)
        storage[key]
      end

      def [](key)
        read(key)
      end

      def write(key, value)
        storage[key] = value
      end

      def []=(key, value)
        write(key, value)
      end

      def delete(key, &block)
        storage.delete(key, &block)
      end

      def fetch(key, default = nil)
        return read(key) if exist?(key)

        return default unless block_given?

        yield
      end

      def up!
        Thread.current[:thread_aware_active] = true
      end

      def down!
        Thread.current[:thread_aware_active] = false
      end

      def active?
        Thread.current[:thread_aware_active] || false
      end

      def flush!
        return unless active?

        down!
        reset!
      end
    end
  end
end
