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
        s = skip_sensitive_data value
        s.respond_to?(:to_json) ? s.to_json : s
      end

      def apply_filters(value)
        value
      end
    end
  end
end
