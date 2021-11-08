# frozen_string_literal: true

require_relative 'job_mapper'

module Jobify
  module CareerJet
    # Mapper to transform a url to a url entity
    class ListJobMapper
      def initialize(api_key, gateway_class = CareerJet::Api)
        @key = api_key
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@key)
      end

      def get_jobs(skill, location)
        data = @gateway.job(skill, location)
        build_entity(data.jobs)
      end

      def build_entity(data)
        DataMapper.new(data, @key).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(jobs, key)
          @jobs = jobs
          @job_mapper = JobMapper.new(key)
        end

        def build_entity
          Entity::ListJob.new(
            id: nil,
            jobs: jobs
          )
        end

        def jobs
          @jobs.map do |job|
            @job_mapper.build_entity(job)
          end
        end
      end
    end
  end
end
