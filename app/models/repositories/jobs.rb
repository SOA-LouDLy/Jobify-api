# frozen_string_literal: true

module Jobify
  module Repository
    # Repository for Job Entities
    class Jobs
      def self.all
        Database::JobOrm.all.map { |db_job| rebuild_entity(db_job) }
      end

      def self.find(entity)
        finding(entity.title)
      end

      def self.finding(title)
        db_job = Database::JobOrm.first(title: title)
        rebuild_entity(db_job)
      end

      def self.find_id(id)
        db_job = Database::JobOrm.first(id: id)
        rebuild_entity(db_job)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Job.new(
          id: nil,
          title: db_record.title,
          date: db_record.date,
          description: db_record.description,
          company: db_record.company,
          locations: db_record.locations,
          url: db_record.url
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_job|
          Jobs.rebuild_entity(db_job)
        end
      end
    end
  end
end
