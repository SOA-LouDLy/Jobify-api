# frozen_string_literal: true

module Jobify
  module Repository
    # Repository for Members
    class Works
      def self.find_id(id)
        rebuild_entity Database::WorkOrm.first(id: id)
      end

      def self.find_organization(name)
        rebuild_entity Database::EducationOrm.first(job_title: name)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Work.new(
          id: db_record.id,
          job_title: db_record.job_title,
          organization: db_record.organization,
          formatted_location: db_record.formatted_location,
          country: db_record.country,
          raw_location: db_record.raw_location,
          starting_date: db_record.starting_date,
          end_date: db_record.end_date,
          months_in_position: db_record.months_in_position,
          description: db_record.description
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_work|
          Works.rebuild_entity(db_work)
        end
      end

      def self.find_or_create(entity)
        Database::WorkOrm.find_or_create(entity.to_attr_hash)
      end
    end
  end
end
