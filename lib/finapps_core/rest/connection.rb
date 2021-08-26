# frozen_string_literal: true

module FinAppsCore
  module REST
    module Connection # :nodoc:
      # @return [Faraday::Connection]
      def faraday(config, logger)
        options = connection_options config

        Faraday.new(options) do |conn|
          conn.use FinAppsCore::Middleware::RaiseError
          init_connection_request conn, config
          init_connection_response conn, logger
          init_connection_auth conn, config

          # Adapter (ensure that the adapter is always last.)
          conn.adapter Faraday.default_adapter
        end
      end

      def init_connection_response(conn, logger)
        conn.response :logger, logger, bodies: true,
                                       headers: true,
                                       formatter: FinAppsCore::Logging::ContenTypeFormatter,
                                       log_level: :debug
        conn.response :json,
                      content_type: /\bjson$/,
                      parser_options: {symbolize_names: true}
      end

      def init_connection_request(conn, config)
        conn.request :accept_json
        conn.request :user_agent
        conn.request :x_consumer_id, config.consumer_id if config.consumer_id
        conn.request :x_tenant_id, config.tenant_id if config.tenant_id
        conn.request :json
        conn.request :retry
        conn.request :multipart
        conn.request :url_encoded
        conn.request :request_id, config.request_id if config.request_id
      end

      def init_connection_auth(conn, config)
        if config.valid_user_credentials?
          conn.request :no_encoding_basic_authentication, config.user_token
        else
          conn.request :tenant_authentication, config.tenant_token
        end
      end

      def connection_options(config)
        {
          url: "#{config.host}/v#{Defaults::API_VERSION}/",
          request: {open_timeout: config.timeout,
                    timeout: config.timeout}
        }
      end
    end
  end
end
