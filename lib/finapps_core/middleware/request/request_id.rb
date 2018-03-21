# frozen_string_literal: true

module FinAppsCore
  module Middleware
    # Adds a header for request id.
    class RequestId < Faraday::Middleware
      KEY = 'X-Request-Id' unless defined? KEY

      def initialize(app, request_id)
        super(app)
        @request_id = request_id.to_s.strip
      end

      def call(env)
        env[:request_headers][KEY] = @request_id
        @app.call(env)
      end
    end
  end
end
