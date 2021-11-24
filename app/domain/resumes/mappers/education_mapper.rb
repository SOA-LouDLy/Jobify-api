# frozen_string_literal: false

module Jobify
  # Mapper to transform section to a section entity
  module Affinda
    # Data Mapper: Section -> Section entity
    class EducationMapper
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
          Jobify::Entity::Education.new(
            id: nil,
            organization: organization,
            accreditation: accreditation,
            grade: grade,
            formatted_location: formatted_location,
            raw_location: raw_location,
            # dates: dates,
            starting_date: starting_date,
            end_date: end_date
          )
        end

        def organization
          @data['organization']
        end

        def accreditation
          @data['accreditation']['inputStr'] unless @data['accreditation'].nil?
        end

        def grade
          @data['grade']
        end

        def formatted_location
          @data['location']['formatted'] unless @data['location'].nil?
        end

        def raw_location
          @data['location']['rawInput'] unless @data['location'].nil?
        end

        def starting_date
          @data['dates']['startDate'] unless @data['location'].nil?
        end

        def end_date
          @data['dates']['completionDate'] unless @data['location'].nil?
        end
      end
    end
  end
end
