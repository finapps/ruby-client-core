# frozen_string_literal: true

using ObjectExtensions
using StringExtensions

module FinAppsCore
  module Middleware
    class RaiseError < Faraday::Response::Middleware # :nodoc:
      SUCCESS_STATUSES = (200..299).freeze
      API_UNAUTHENTICATED = 401
      FORBIDDEN = 403
      CONNECTION_FAILED_STATUS = 407
      API_SESSION_TIMEOUT = 419
      LOCKOUT_MESSAGE = 'account is locked'

      def on_complete(env)
        return if SUCCESS_STATUSES.include?(env[:status])

        failures env
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

      def failures(env)
        api_authentication_fail env
        api_session_timeout_fail env
        locked_user_fail env
        connection_fail env

        fail(Faraday::ClientError, response_values(env))
      end

      def locked_user_fail(env)
        return unless user_is_locked?(env)

        fail(FinAppsCore::UserLockoutError, 'User is Locked')
      end

      def api_session_timeout_fail(env)
        return unless env[:status] == API_SESSION_TIMEOUT

        fail(FinAppsCore::ApiSessionTimeoutError, 'API Session Timed out')
      end

      def connection_fail(env)
        return unless env[:status] == CONNECTION_FAILED_STATUS

        fail(FinAppsCore::ConnectionFailedError, 'Connection Failed')
      end

      def api_authentication_fail(env)
        return unless env[:status] == API_UNAUTHENTICATED

        fail(FinAppsCore::ApiUnauthenticatedError, 'API Invalid Session')
      end

      def error_messages(body)
        return nil if empty?(body)

        hash = to_hash body
        messages hash
      end

      def messages(hash)
        return nil unless hash.respond_to?(:key?) && hash.key?(:messages)

        hash[:messages]
      end

      def to_hash(source)
        return source unless source.is_a?(String)

        symbolize(source.json_to_hash)
      end

      def empty?(obj)
        obj.nil? || (obj.respond_to?(:empty?) && obj.empty?)
      end

      def user_is_locked?(env)
        env.status == FORBIDDEN &&
          error_messages(env.body)&.[](0)&.downcase == LOCKOUT_MESSAGE
      end

      def symbolize(obj)
        return obj.each_with_object({}) {|(k, v), memo| memo[k.to_sym] = symbolize(v);  } if obj.is_a? Hash
        return obj.each_with_object([]) {|v, memo| memo << symbolize(v); } if obj.is_a? Array

        obj
      end
    end
  end
end
