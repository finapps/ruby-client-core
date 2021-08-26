# frozen_string_literal: true

require 'faraday/logging/formatter'

module FinAppsCore
  module Logging
    class ContenTypeFormatter < Faraday::Logging::Formatter
      CONTENT_TYPE = 'Content-Type' unless defined?(ContenTypeFormatter::CONTENT_TYPE)

      def response(env)
        status = proc { "Status #{env.status}" }
        public_send(log_level, 'response', &status)

        log_headers('response', env.response_headers) if log_headers?(:response)
        log_body('response', env[:body]) if env[:body] && log_body?(:response) && loggable?(env)
      end

      private

      def loggable?(env)
        loggable_types = ['application/json', 'text/plain']
        process_response_type?(env, loggable_types)
      end

      def process_response_type?(env, content_types)
        type = response_type(env)
        content_types.empty? || content_types.any? do |pattern|
          pattern.is_a?(Regexp) ? type.match?(pattern) : type == pattern
        end
      end

      def response_type(env)
        type = env[:response_headers][CONTENT_TYPE].to_s
        type = type.split(';', 2).first if type.index(';')
        type
      end
    end
  end
end
