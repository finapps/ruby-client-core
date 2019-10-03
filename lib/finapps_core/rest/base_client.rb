# frozen_string_literal: true

require_relative './configuration.rb'
require_relative './connection.rb'
require_relative '../utils/loggeable'
require_relative '../utils/validatable'

using ObjectExtensions
using StringExtensions

module FinAppsCore
  module REST
    # base client functionality
    class BaseClient
      include ::FinAppsCore::Utils::Loggeable
      include ::FinAppsCore::Utils::Validatable
      include ::FinAppsCore::REST::Connection

      attr_reader :config

      def initialize(options, logger = nil)
        @config = ::FinAppsCore::REST::Configuration.new options
        @logger = logger
      end

      # Returns an initialized Faraday connection object.
      #
      # @return Faraday::Connection.
      def connection
        @connection ||= faraday(config, logger)
      end

      # Performs HTTP GET, POST, UPDATE and DELETE requests.
      # You shouldn't need to use this method directly, but it can be useful for debugging.
      # Returns a hash obtained from parsing the JSON object in the response body.
      #
      # @param [String] path
      # @param [String] method
      # @param [Hash] params
      # @return [Hash,Array<String>]
      def send_request(path, method, params = {})
        not_blank(path, :path)
        not_blank(method, :method)

        response, error_messages = execute_request(path, method, params)
        result = block_given? ? yield(response) : response_body(response)

        [result, error_messages]
      end

      # Defines methods to perform HTTP GET, POST, PUT and DELETE requests.
      # Returns a hash obtained from parsing the JSON object in the response body.
      #
      def method_missing(method_id, *arguments, &block)
        if %i[get post put delete].include? method_id
          send_to_connection method_id, arguments
        else
          super
        end
      end

      def respond_to_missing?(method_sym, include_private = false)
        %i[get post put delete].include?(method_sym) ? true : super
      end

      private

      def response_body(response)
        response.body if response.respond_to?(:body) && !response.body.to_s.empty?
      end

      def send_to_connection(method_id, arguments)
        connection.send(method_id) do |req|
          req.url arguments.first
          req.body = arguments[1] unless method_id == :get
        end
      end

      def execute_request(path, method, params)
        response = nil
        errors = []

        begin
          response = execute_method path, method, params
        rescue FinAppsCore::InvalidArgumentsError,
               FinAppsCore::MissingArgumentsError,
               Faraday::Error::ConnectionFailed => e
          handle_error e
        rescue Faraday::ClientError => e
          errors = handle_client_error(e)
        end

        [response, errors]
      end

      def handle_error(error)
        logger.fatal "#{self.class}##{__method__} => #{error}"
        raise error
      end

      def handle_client_error(error)
        logger.warn "#{self.class}##{__method__} => #{error.class.name}, #{error}"
        error.response && error.response[:error_messages] ? error.response[:error_messages] : [error.message]
      end

      def execute_method(path, method, params)
        case method
        when :get
          get(path)
        when :post
          post(path, params)
        when :put
          put(path, params)
        when :delete
          delete(path, params)
        else
          raise FinAppsCore::UnsupportedHttpMethodError, "Method not supported: #{method}."
        end
      end
    end
  end
end
