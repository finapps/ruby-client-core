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
        non_nil_options = options.select {|_, value| !value.nil? }
        FinAppsCore::REST::Defaults::DEFAULTS.merge(non_nil_options)
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
    end
  end
end
