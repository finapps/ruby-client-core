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
        super
      end

      def on_complete(env)
        debug "#{self.class.name}##{__method__} => Response Headers: #{dump env.response_headers}"
        debug "#{self.class.name}##{__method__} => Response Body: #{dump env.body}" if env.body
      end

      private

      def dump(value)
        s = skip_sensitive_data(value.is_a?(Array) ? value.to_h : value)
        s.nil? ? 'NO-CONTENT' : s.to_json
      end

      def new_logger
        logger = Logger.new(STDOUT)
        logger.level = FinAppsCore::REST::Defaults::DEFAULTS[:log_level]
        logger
      end
    end
  end
end
