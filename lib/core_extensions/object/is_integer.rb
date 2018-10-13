# frozen_string_literal: true

module ObjectExtensions
  refine Object do
    def integer?
      Integer(self)
    rescue StandardError
      false
    end
  end
end
