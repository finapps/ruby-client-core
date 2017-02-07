# frozen_string_literal: true
require 'faraday' unless defined? Faraday

module FinAppsCore
  module Middleware
    autoload :AcceptJson, 'finapps_core/middleware/request/accept_json'
    autoload :UserAgent, 'finapps_core/middleware/request/user_agent'
    autoload :NoEncodingBasicAuthentication, 'finapps_core/middleware/request/no_encoding_basic_authentication'
    autoload :TenantAuthentication, 'finapps_core/middleware/request/tenant_authentication'
    autoload :CustomLogger, 'finapps_core/middleware/response/custom_logger'

    if Faraday::Middleware.respond_to? :register_middleware
      Faraday::Request.register_middleware \
        accept_json: -> { AcceptJson },
        user_agent: -> { UserAgent },
        no_encoding_basic_authentication: -> { NoEncodingBasicAuthentication },
        tenant_authentication: -> { TenantAuthentication }
      Faraday::Response.register_middleware \
        custom_logger: -> { CustomLogger }
    end
  end
end
