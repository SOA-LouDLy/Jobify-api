# frozen_string_literal: true

module Jobify
  module Repository
    # Repository for Members
    class Educations
      def self.find_id(id)
        rebuild_entity Database::EducationOrm.first(id: id)
      end

      def self.find_organization(name)
        rebuild_entity Database::EducationOrm.first(organization: name)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Education.new(
          id: db_record.id,
          organization: db_record.organization,
          accreditation: db_record.accreditation,
          grade: db_record.grade,
          formatted_location: db_record.formatted_location,
          raw_location: db_record.raw_location,
          starting_date: db_record.starting_date,
          end_date: db_record.end_date
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_education|
          Educations.rebuild_entity(db_education)
        end
      end

      def self.find_or_create(entity)
        Database::EducationOrm.find_or_create(entity.to_attr_hash)
      end
    end
  end
end
