# frozen_string_literal: true
using ObjectExtensions
using StringExtensions

module FinAppsCore
  module Utils
    # Adds validation capabilities when included into other classes
    module Validatable

      def not_blank(value, name=nil)
        raise FinAppsCore::MissingArgumentsError.new "Missing argument#{": #{name}" unless name.nil?}" if value.blank?
      end
    end
  end
end
