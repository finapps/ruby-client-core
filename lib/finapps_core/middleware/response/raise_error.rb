# frozen_string_literal: true

using ObjectExtensions
using StringExtensions

module FinAppsCore
  module Middleware
    class RaiseError < Faraday::Response::Middleware # :nodoc:
      SUCCESS_STATUSES = (200..299).freeze
      API_UNAUTHENTICATED = 401
      CONNECTION_FAILED_STATUS = 407
      API_SESSION_TIMEOUT = 419

      def on_complete(env)
        return if SUCCESS_STATUSES.include?(env[:status])

        raise(FinAppsCore::ApiUnauthenticatedError, 'API Invalid Session') if env[:status] == API_UNAUTHENTICATED
        raise(FinAppsCore::ApiSessionTimeoutError, 'API Session Timed out') if env[:status] == API_SESSION_TIMEOUT
        raise(FinAppsCore::ConnectionFailedError, 'Connection Failed') if env[:status] == CONNECTION_FAILED_STATUS

        raise(Faraday::Error::ClientError, response_values(env))
      end

      def response_values(env)
        {
          status: env.status,
          headers: env.response_headers,
          body: env.body,
          error_messages: error_messages(env.body)
        }
      end

      private

      def error_messages(body)
        return nil if empty?(body)

        hash = to_hash body
        messages hash
      end

      def messages(hash)
        return nil unless hash.respond_to?(:key?) && hash.key?('messages')

        hash['messages']
      end

      def to_hash(source)
        return source unless source.is_a?(String)

        source.json_to_hash
      end

      def empty?(obj)
        obj.nil? || (obj.respond_to?(:empty?) && obj.empty?)
      end
    end
  end
end
