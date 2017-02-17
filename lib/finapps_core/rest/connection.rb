# frozen_string_literal: true
module FinAppsCore
  module REST
    module Connection # :nodoc:
      # @return [Faraday::Connection]
      def faraday(config, logger)
        options = {
          url: "#{config.host}/v#{Defaults::API_VERSION}/",
          request: {open_timeout: config.timeout,
                    timeout: config.timeout}
        }

        Faraday.new(options) do |conn|
          conn.request :accept_json
          conn.request :user_agent
          conn.request :tenant_authentication, config.tenant_token unless config.valid_user_credentials?
          conn.request :json
          conn.request :retry
          conn.request :multipart
          conn.request :url_encoded
          conn.request :no_encoding_basic_authentication, config.user_token if config.valid_user_credentials?

          conn.use FinAppsCore::Middleware::RaiseError
          conn.response :rashify
          conn.response :json, content_type: /\bjson$/
          conn.response :custom_logger, logger, bodies: (ENV['SILENT_LOG_BODIES'] != 'true')

          # Adapter (ensure that the adapter is always last.)
          conn.adapter :typhoeus
        end
      end
      module_function :faraday # becomes available as a *private instance method* to classes that mix in the module
    end
  end
end
