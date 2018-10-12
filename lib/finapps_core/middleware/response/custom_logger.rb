# frozen_string_literal: true

require 'logger'

module FinAppsCore
  module Middleware
    class CustomLogger < Faraday::Response::Middleware
      extend Forwardable
      include FinAppsCore::Utils::ParameterFilter

      DEFAULT_OPTIONS = {bodies: false}.freeze

      def initialize(app, logger=nil, options={})
        super(app)
        @logger = logger || new_logger
        @options = DEFAULT_OPTIONS.merge(options)
      end

      def_delegators :@logger, :debug

      def call(env)
        debug "#{self.class.name}##{__method__} => URL: #{env.method.upcase} #{env.url}"
        debug "#{self.class.name}##{__method__} => Request Headers: #{dump env.request_headers}"
        if env[:body] && log_body?(:request)
          debug "#{self.class.name}##{__method__} => Request Response: #{dump env[:body]}"
        end
        super
      end

      def on_complete(env)
        debug "#{self.class.name}##{__method__} => Response Headers: #{dump env.response_headers}"
        if env.body && log_body?(:response)
          debug "#{self.class.name}##{__method__} => Response Body: #{dump env.body}"
        end
      end

      private

      def dump(value)
        s = skip_sensitive_data(value.is_a?(Array) ? value.to_h : value)
        s.nil? ? 'NO-CONTENT' : s.to_json
      end

      def log_body?(type)
        case @options[:bodies]
        when Hash then
          @options[:bodies][type]
        else
          @options[:bodies]
        end
      end

      def new_logger
        logger = Logger.new(STDOUT)
        logger.level = FinAppsCore::REST::Defaults::DEFAULTS[:log_level]
        logger
      end
    end
  end
end
