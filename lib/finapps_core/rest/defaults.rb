# frozen_string_literal: true
module FinAppsCore
  module REST
    module Defaults
      API_VERSION = '2'

      # noinspection SpellCheckingInspection
      DEFAULTS = {
        host:             'https://api.financialapps.com',
        user_identifier:  nil,
        user_token:       nil,
        timeout:          30,
        proxy:            nil,
        retry_limit:      1,
        log_level:        Logger::INFO
      }.freeze

    end
  end
end
