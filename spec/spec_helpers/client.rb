# frozen_string_literal: true

module SpecHelpers
  module Client
    def client
      FinAppsCore::REST::BaseClient.new tenant_token: :tenant_token
    end
  end
end
