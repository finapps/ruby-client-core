# frozen_string_literal: true

module FinAppsCore
  module Utils
    module ParameterFilter
      using StringExtensions
      PROTECTED_KEYS = %w[login login1 username password password1 password_confirm token
                          x-tenant-token authorization routing_no account_no tpr_id messages].freeze

      def skip_sensitive_data(param)
        hash = param.is_a?(String) ? param.json_to_hash : param

        if hash.is_a? Hash
          cloned = hash.clone
          cloned.each {|key, v| redact key, v }
        else
          hash
        end
      end

      private

      def redact(key, value)
        if PROTECTED_KEYS.include? key.to_s.downcase
          value = '[REDACTED]'
        elsif value.is_a?(Hash)
          value = skip_sensitive_data(value)
        elsif value.is_a?(Array)
          value = value.map {|v| v.is_a?(Hash) ? skip_sensitive_data(v) : v }
        end

        [key, value]
      end
    end
  end
end
