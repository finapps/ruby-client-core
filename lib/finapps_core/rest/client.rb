# frozen_string_literal: true
module FinAppsCore
  module REST
    class Client < BaseClient # :nodoc:
      using ObjectExtensions
      using StringExtensions

      include FinAppsCore::REST::Defaults

      # @param [String] tenant_identifier
      # @param [String] tenant_token
      # @param [Hash] options
      # @return [FinAppsCore::REST::Client]
      def initialize(tenant_identifier, tenant_token, options={}, logger=nil)
        raise FinAppsCore::MissingArgumentsError.new 'Invalid company_identifier.' if tenant_identifier.blank?
        raise FinAppsCore::MissingArgumentsError.new 'Invalid company_token.' if tenant_token.blank?

        merged_options = options.merge(tenant_identifier: tenant_identifier,
                                       tenant_token: tenant_token)
        super(merged_options, logger)
      end

      def version
        @version ||= FinAppsCore::REST::Version.new self
      end
    end
  end
end
