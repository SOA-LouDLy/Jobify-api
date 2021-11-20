# frozen_string_literal: true

module Jobify
  module Repository
    # Repository for Members
    class Sections
      def self.find_id(id)
        rebuild_entity Database::SectionOrm.first(id: id)
      end

      def self.find_organization(name)
        rebuild_entity Database::SectionOrm.first(section_type: name)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Section.new(
          id: db_record.id,
          section_type: db_record.section_type,
          text: db_record.text
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_section|
          Sections.rebuild_entity(db_section)
        end
      end

      def self.find_or_create(entity)
        Database::SectionOrm.find_or_create(entity.to_attr_hash)
      end
    end
  end
end
