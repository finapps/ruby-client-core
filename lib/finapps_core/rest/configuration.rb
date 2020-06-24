# frozen_string_literal: true

module FinAppsCore
  module REST
    # Represents the client configuration options
    class Configuration # :nodoc:
      using ObjectExtensions

      attr_accessor :tenant_token, :user_identifier, :user_token,
                    :host, :proxy, :timeout, :retry_limit, :rashify,
                    :log_level, :request_id, :consumer_id

      def initialize(options = {})
        FinAppsCore::REST::Defaults::DEFAULTS.merge(remove_empty_options(options))
                                             .each {|key, value| public_send("#{key}=", value) }

        fail FinAppsCore::InvalidArgumentsError, "Invalid argument. {host: #{host}}" unless valid_host?
        unless timeout.integer?
          fail FinAppsCore::InvalidArgumentsError, "Invalid argument. {timeout: #{timeout}}"
        end
      end

      def valid_user_credentials?
        FinAppsCore::REST::Credentials.new(user_identifier, user_token).valid?
      end

      private

      def valid_host?
        host.start_with?('http://', 'https://')
      end

      def remove_empty_options(hash)
        hash.reject {|_, value| value.nil? }
      end
    end
  end
end
