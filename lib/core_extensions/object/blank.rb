# frozen_string_literal: true
module ObjectExtensions
  refine Object do
    # An object is blank if it's false, empty, or a whitespace string.
    # For example, +false+, '', '   ', +nil+, [], and {} are all blank.
    #
    # This simplifies
    #
    #   !address || address.empty?
    #
    # to
    #
    #   address.blank?
    #
    # @return [true, false]
    def blank?
      respond_to?(:empty?) ? !!empty? : !self
    end

    # An object is present if it's not blank.
    #
    # @return [true, false]
    def present?
      !blank?
    end
  end
end

module StringExtensions
  refine String do
    BLANK_RE = /\A[[:space:]]*\z/

    # A string is blank if it's empty or contains whitespaces only:
    #
    #   ''.blank?       # => true
    #   '   '.blank?    # => true
    #   "\t\n\r".blank? # => true
    #   ' blah '.blank? # => false
    #
    # Unicode whitespace is supported:
    #
    #   "\u00a0".blank? # => true
    #
    # @return [true, false]
    def blank?
      match BLANK_RE
    end
  end
end
