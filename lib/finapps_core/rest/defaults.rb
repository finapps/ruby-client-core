# frozen_string_literal: true

require 'logger'

module FinAppsCore
  module REST
    module Defaults
      API_VERSION = '4'

      # noinspection SpellCheckingInspection
      DEFAULTS = {
        host: 'https://api.finclear.io',
        timeout: 30,
        proxy: nil,
        log_level: Logger::UNKNOWN
      }.freeze
    end
  end
end
