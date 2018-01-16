# frozen_string_literal: true

module FinAppsCore
  module REST
    module Defaults
      API_VERSION = '3'

      # noinspection SpellCheckingInspection
      DEFAULTS = {
        host:             'https://api.financialapps.com',
        timeout:          30,
        proxy:            nil,
        retry_limit:      1,
        log_level:        Logger::INFO
      }.freeze
    end
  end
end
