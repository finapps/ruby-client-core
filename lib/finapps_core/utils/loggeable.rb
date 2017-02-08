# frozen_string_literal: true
module FinAppsCore
  module Utils
    # Adds logging capabilities when included into other classes
    module Loggeable
      def logger
        @logger ||= begin
          require 'logger'
          Logger.new(STDOUT).tap {|log| log.level = Logger::FATAL }
        end
      end
    end
  end
end
