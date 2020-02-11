# frozen_string_literal: true

module FinAppsCore
  module Middleware
    # Adds a header to specify consumer to retrieve data for
    class XConsumerId < Faraday::Middleware
      KEY = 'X-Consumer-ID' unless defined? KEY

      def initialize(app, x_consumer_id)
        super(app)
        @x_consumer_id = x_consumer_id.to_s.strip
      end

      def call(env)
        env[:request_headers][KEY] ||= @x_consumer_id
        @app.call(env)
      end
    end
  end
end
