# frozen_string_literal: true

require 'logger'

module FinAppsCore
  module REST
    module Defaults
      API_VERSION = '3'

      # noinspection SpellCheckingInspection
      DEFAULTS = {
        host:             'https://api.financialapps.com',
        timeout:          30,
        proxy:            nil,
        log_level:        Logger::DEBUG
      }.freeze
    end
  end
end
