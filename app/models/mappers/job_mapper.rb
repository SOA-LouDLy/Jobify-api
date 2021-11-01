# frozen_string_literal: true

module Jobify
  module CareerJet
    # Mapper to transform a CarrerJet job to a Job entity
    class JobMapper
      def initialize(api_key, gateway_class = CareerJet::Api)
        @key = api_key
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@key)
      end

      def get_jobs(skill, location)
        data = @gateway.job(skill, location)
        data.jobs.map { |job| build_entity(job) }
      end

      def build_entity(data)
        DataMapper.new(data).build_entity
      end
    end

    # Extracts entity specific elements from data structure
    class DataMapper
      def initialize(data)
        @data = data
      end

      def build_entity
        Jobify::Entity::Job.new(
          date: date,
          url: url,
          title: title,
          description: description,
          company: company,
          locations: locations
        )
      end

      def date
        @data.date
      end

      def url
        @data.url
      end

      def title
        @data.title
      end

      def description
        @data.description
      end

      def company
        @data.company
      end

      def locations
        @data.locations
      end
    end
  end
end
