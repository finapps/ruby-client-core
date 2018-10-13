# frozen_string_literal: true

module FinAppsCore
  module REST
    module Connection # :nodoc:
      # @return [Faraday::Connection]
      def faraday(config, logger)
        options = connection_options config

        Faraday.new(options) do |conn|
          conn.request :accept_json
          conn.request :user_agent
          if config.valid_user_credentials?
            conn.request :no_encoding_basic_authentication, config.user_token
          else
            conn.request :tenant_authentication, config.tenant_token
          end
          conn.request :json
          conn.request :retry
          conn.request :multipart
          conn.request :url_encoded
          conn.request :request_id, config.request_id if config.request_id

          conn.use FinAppsCore::Middleware::RaiseError
          conn.response :rashify if config.rashify
          conn.response :json, content_type: /\bjson$/
          conn.response :custom_logger, logger, bodies: true

          # Adapter (ensure that the adapter is always last.)
          conn.adapter Faraday.default_adapter
        end
      end
      module_function :faraday

      def connection_options(config)
        {
          url: "#{config.host}/v#{Defaults::API_VERSION}/",
          request: { open_timeout: config.timeout,
                     timeout: config.timeout }
        }
      end
      module_function :connection_options
    end
  end
end
