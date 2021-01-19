# frozen_string_literal: true

module FinAppsCore
  module Middleware
    # Adds a header to specify tenant to retrieve data for
    class XTenantId < Faraday::Middleware
      KEY = 'X-Tenant-ID' unless defined? KEY

      def initialize(app, x_tenant_id)
        super(app)
        @x_tenant_id = x_tenant_id.to_s.strip
      end

      def call(env)
        env[:request_headers][KEY] ||= @x_tenant_id
        @app.call(env)
      end
    end
  end
end
