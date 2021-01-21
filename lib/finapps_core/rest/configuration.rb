# frozen_string_literal: true

module FinAppsCore
  module REST
    # Represents the client configuration options
    class Configuration # :nodoc:
      using ObjectExtensions

      attr_accessor :tenant_token, :user_identifier, :user_token,
                    :host, :proxy, :timeout, :retry_limit, :rashify,
                    :log_level, :request_id, :consumer_id, :tenant_id

      def initialize(options = {})
        assign_attributes FinAppsCore::REST::Defaults::DEFAULTS
          .merge(options.compact)
        fail_invalid_timeout
        fail_invalid_host
        @host = @host.chomp('/')
      end

      def valid_user_credentials?
        FinAppsCore::REST::Credentials.new(user_identifier, user_token).valid?
      end

      private

      def assign_attributes(new_attributes)
        unless new_attributes.respond_to?(:each_pair)
          fail ArgumentError, 'When assigning attributes, '\
            "you must pass a hash argument, #{new_attributes.class} passed."
        end
        return if new_attributes.empty?

        _assign_attributes new_attributes
      end

      def _assign_attributes(attributes)
        attributes.each {|key, value| _assign_attribute(key, value) }
      end

      def _assign_attribute(key, value)
        setter = :"#{key}="
        fail UnknownAttributeError.new(self, key.to_s) unless respond_to?(setter)

        public_send(setter, value)
      end

      def fail_invalid_host
        return if valid_host?

        fail FinAppsCore::InvalidArgumentsError,
             "Invalid argument. {host: #{host}}"
      end

      def fail_invalid_timeout
        return if timeout.integer?

        fail FinAppsCore::InvalidArgumentsError,
             "Invalid argument. {timeout: #{timeout}}"
      end

      def valid_host?
        host.start_with?('http://', 'https://')
      end
    end
  end
end
