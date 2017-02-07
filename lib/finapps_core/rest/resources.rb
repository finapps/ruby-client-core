# frozen_string_literal: true
module FinAppsCore
  module REST
    class Resources # :nodoc:
      include FinAppsCore::Utils::ParameterFilter
      require 'erb'

      attr_reader :client

      # @param [FinAppsCore::REST::Client] client
      # @return [FinAppsCore::REST::Resources]
      def initialize(client)
        raise MissingArgumentsError.new 'Missing argument: client.' if client.nil?
        raise InvalidArgumentsError.new 'Invalid argument: client.' unless client.is_a?(FinAppsCore::REST::Client)

        @client = client
      end

      def list(path=nil)
        path = end_point.to_s if path.nil?
        request_with_body(path, :get, {})
      end

      def create(params={}, path=nil)
        request_with_body(path, :post, params)
      end

      def update(params={}, path=nil)
        request_with_body(path, :put, params)
      end

      def show(id=nil, path=nil)
        request_without_body(path, :get, id)
      end

      def destroy(id=nil, path=nil)
        request_without_body(path, :delete, id)
      end

      def request_without_body(path, method, id)
        raise MissingArgumentsError.new 'Missing argument: id.' if id.nil? && path.nil?
        path = "#{end_point}/:id".sub ':id', ERB::Util.url_encode(id) if path.nil?
        request_with_body path, method, {}
      end

      def request_with_body(path, method, params)
        path = end_point if path.nil?
        logger.debug "#{self.class.name}##{__method__} => path: #{path} params: #{skip_sensitive_data(params)}"

        client.send_request path, method, params
      end

      protected

      def logger
        client.logger
      end

      def end_point
        self.class.name.split('::').last.downcase
      end
    end
  end
end
