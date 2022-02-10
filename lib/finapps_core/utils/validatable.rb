# frozen_string_literal: true

using ObjectExtensions
using StringExtensions

module FinAppsCore
  module Utils
    # Adds validation capabilities when included into other classes
    module Validatable
      def not_blank(value, name = nil)
        fail FinAppsCore::MissingArgumentsError, name.nil? ? nil : ": #{name}" if nil_or_empty?(value)
      end

      def nil_or_empty?(value)
        !value || (value.respond_to?(:empty?) && value.empty?)
      end
    end
  end
end
