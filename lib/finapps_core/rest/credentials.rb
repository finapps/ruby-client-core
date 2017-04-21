# frozen_string_literal: true
module FinAppsCore
  module REST
    # represents both tenant and user credentials
    class Credentials
      attr_reader :identifier, :token

      def initialize(identifier, token)
        @identifier = identifier
        @token = token
      end

      def valid?
        !token.nil?
      end
    end
  end
end
