# frozen_string_literal: true
module FinAppsCore
  module REST
    class Version < FinAppsCore::REST::Resources # :nodoc:
      def show
        super nil, end_point
      end
    end
  end
end
