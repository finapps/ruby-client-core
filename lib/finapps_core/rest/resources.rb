# frozen_string_literal: true

require_relative '../utils/loggeable'
require_relative '../utils/validatable'

module FinAppsCore
  module REST
    class Resources # :nodoc:
      include FinAppsCore::Utils::Loggeable
      include FinAppsCore::Utils::Validatable
      require 'erb'

      attr_reader :client

      # @param [FinAppsCore::REST::Client] client
      # @return [FinAppsCore::REST::Resources]
      def initialize(client)
        not_blank(client, :client)
        @client = client
        @logger = client.logger if client.respond_to?(:logger)
      end

      def list(path = nil)
        path = end_point.to_s if path.nil?
        send_request path, :get
      end

      def show(id = nil, path = nil)
        send_request_for_id path, :get, id
      end

      def create(params = {}, path = nil)
        send_request path, :post, params
      end

      def update(params = {}, path = nil)
        send_request path, :put, params
      end

      def destroy(id = nil, path = nil)
        send_request_for_id path, :delete, id
      end

      def end_point
        self.class.name.split('::').last.downcase
      end

      def send_request_for_id(path, method, id)
        path = resource_path(id) if path.nil?
        send_request path, method
      end

      def resource_path(id)
        not_blank id, :id
        "#{end_point}/#{ERB::Util.url_encode(id)}"
      end

      def send_request(path, method, params = {})
        path = end_point if path.nil?
        logger.debug "#{self.class.name}##{__method__} => path: #{path} params: #{params}"

        client.send_request path, method, params
      end
    end
  end
end
