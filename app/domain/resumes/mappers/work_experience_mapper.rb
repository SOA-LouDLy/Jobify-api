# frozen_string_literal: false

module Jobify
  # Mapper to transform skill to a skill entity
  module Affinda
    # Data Mapper: Skill -> Skill entity
    class WorkExperienceMapper
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
          Jobify::Entity::Work.new(
            id: nil,
            job_title: job_title,
            organization: organization,
            formatted_location: formatted_location,
            country: country,
            raw_location: raw_location,
            # dates: dates,
            starting_date: starting_date,
            end_date: end_date,
            months_in_position: months_in_position,
            description: description
          )
        end

        def job_title
          @data['jobTitle']
        end

        def organization
          @data['organization']
        end

        def formatted_location
          @data['location']['formatted'] unless @data['location'].nil?
        end

        def country
          @data['location']['country'] unless @data['location'].nil?
        end

        def raw_location
          @data['location']['rawInput'] unless @data['location'].nil?
        end

        def starting_date
          @data['dates']['startDate'] unless @data['dates'].nil?
        end

        def end_date
          @data['dates']['endDate'] unless @data['dates'].nil?
        end

        def months_in_position
          @data['dates']['monthsInPosition'] unless @data['dates'].nil?
        end

        def description
          @data['jobDescription']
        end
      end
    end
  end
end
