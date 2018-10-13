# frozen_string_literal: true

module FinAppsCore
  module Utils
    module ParameterFilter
      include ::FinAppsCore::Utils::Loggeable
      using StringExtensions
      PROTECTED_KEYS = %w[login login1 username password password1 password_confirm token
                          x-tenant-token authorization routing_no account_no tpr_id].freeze

      def skip_sensitive_data(param)
        hash = param.is_a?(String) ? param.json_to_hash : param

        if hash.is_a? Hash
          clone_and_redact hash
        else
          hash || 'NO-CONTENT'
        end
      end

      private

      def clone_and_redact(hash)
        cloned = hash.clone
        cloned.each {|key, value| cloned[key] = redact(key, value) }
        cloned
      end

      def redact(key, value)
        if PROTECTED_KEYS.include? key.to_s.downcase
          '[REDACTED]'
        elsif value.is_a? Hash
          skip_sensitive_data value
        else
          value || 'NO-CONTENT'
        end
      end
    end
  end
end
