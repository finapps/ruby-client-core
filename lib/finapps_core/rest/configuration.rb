# frozen_string_literal: true
module FinAppsCore
  module REST
    # Represents the client configuration options
    class Configuration # :nodoc:
      using ObjectExtensions

      attr_accessor :host,
                    :tenant_identifier, :tenant_token,
                    :user_identifier, :user_token,
                    :proxy, :timeout, :retry_limit, :log_level

      def initialize(options={})
        FinAppsCore::REST::Defaults::DEFAULTS.merge(remove_empty_options(options))
                                             .each {|key, value| public_send("#{key}=", value) }

        raise FinAppsCore::InvalidArgumentsError.new "Invalid argument. {host: #{host}}" unless valid_host?
        raise FinAppsCore::InvalidArgumentsError.new "Invalid argument. {timeout: #{timeout}}" unless timeout.integer?
      end

      def valid_user_credentials?
        FinAppsCore::REST::Credentials.new(user_identifier, user_token).valid?
      end

      private

      def valid_host?
        host.start_with?('http://', 'https://')
      end

      def remove_empty_options(hash)
        hash.select {|_, value| !value.nil? }
      end
    end
  end
end
