# frozen_string_literal: true

module Jobify
  module Mapper
    # Resume fields analysis
    class Analysis
      def initialize(resume)
        @resume = resume
      end

      def analysis
        Jobify::Entity::Fields.new(@resume).report
      end
    end
  end
end
