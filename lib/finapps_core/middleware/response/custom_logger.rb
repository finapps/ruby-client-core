# frozen_string_literal: true

require 'logger'

module FinAppsCore
  module Middleware
    class CustomLogger < Faraday::Response::Logger
      include FinAppsCore::Utils::ParameterFilter

      private

      def dump_headers(headers)
        dump headers
      end

      def dump_body(body)
        dump body
      end

      def dump(value)
        skip_sensitive_data(value) || 'NO-CONTENT'
      end
    end
  end
end
