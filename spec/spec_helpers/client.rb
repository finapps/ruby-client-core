# frozen_string_literal: true

module SpecHelpers
  module Client
    def client
      FinAppsCore::REST::Client.new :tenant_id, :tenant_token
    end
  end
end
