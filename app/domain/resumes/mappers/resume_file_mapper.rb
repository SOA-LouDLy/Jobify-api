# frozen_string_literal: false

module Jobify
  # Provide access to encoded resume data
  module Affinda
    # Data Mapper: Resume encoded -> ResumeEncoded entity
    class ResumeFileMapper
      def self.build_entity(data)
        DataMapper.new(data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          Jobify::Entity::ResumeFile.new(
            id: nil,
            content: content,
            result: nil
          )
        end

        def content
          @data
        end
      end
    end
  end
end
