# frozen_string_literal: true

require_relative 'jobs'

module Jobify
  module Repository
    # Repository for List of courses
    class ListJobs
      def self.find_id(id)
        rebuild_entity Database::ListJobOrm.first(id: id)
      end

      def self.find(entity)
        find_title(entity.jobs[0].title)
      end

      def self.find_title(title)
        Database::JobOrm.first(title: title)
        # rebuild_entity(db_record)
      end

      def self.create(entity)
        raise 'Job already exists' if find(entity)

        db_project = PersistJob.new(entity).call
        rebuild_entity(db_project)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        db_record.map do |record|
          Entity::Job.new(
            id: nil,
            title: record[:title],
            date: record[:date],
            description: record[:description],
            company: record[:company],
            locations: record[:locations],
            url: record[:url]
        )
        end
      end

      # Helper class to persist jobs a
      class PersistJob
        def initialize(entity)
          @entity = entity
        end

        def call
          jobs = @entity.to_hash[:jobs]
          # Database::JobOrm.create(@entity.to_attr_hash)
          jobs.map do |job|
            Database::JobOrm.create(job.reject { |key, _| [:id].include? key })
          end
        end
      end
    end
  end
end
