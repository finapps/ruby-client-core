# frozen_string_literal: true

module FinAppsCore
  module Middleware
    # Adds a custom header for tenant level authorization.
    # If the value for this header already exists, it is not overriden.
    class TenantAuthentication < Faraday::Middleware
      KEY = 'X-Tenant-Token' unless defined? KEY

      def initialize(app, token)
        super(app)
        @header_value = token.to_s.strip
      end

      def call(env)
        env[:request_headers][KEY] ||= @header_value
        @app.call(env)
      end
    end
  end
end
