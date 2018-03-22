# frozen_string_literal: true

module FinAppsCore
  module Utils
    # Adds logging capabilities when included into other classes
    module Loggeable
      def logger
        @logger ||= begin
          require 'logger'
          logger = Logger.new(STDOUT)
          logger.level = FinAppsCore::REST::Defaults::DEFAULTS[:log_level]
          logger
        end
      end
    end
  end
end
