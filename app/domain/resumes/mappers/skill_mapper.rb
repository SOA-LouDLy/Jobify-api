# frozen_string_literal: false

module Jobify
  # Mapper to transform skill to a skill entity
  module Affinda
    # Data Mapper: Skill -> Skill entity
    class SkillMapper
      def initialize(cv_token, gateway_class = Affinda::Api)
        @key = cv_token
        @gateway_class = gateway_class
        # @gateway = @gateway_class.new(@key)
      end

      def self.build_entity(data)
        DataMapper.new(data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          Jobify::Entity::Skill.new(
            id: nil,
            name: name,
            experience: experience,
            type: type
          )
        end

        def name
          @data['name']
        end

        def experience
          @data['numberOfMonths']
        end

        def type
          @data['type']
        end
      end
    end
  end
end
