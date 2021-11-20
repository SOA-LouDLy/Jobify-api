# frozen_string_literal: true

module Jobify
  module Repository
    # Repository for Members
    class Skills
      def self.find_id(id)
        rebuild_entity Database::SkillOrm.first(id: id)
      end

      def self.find_organization(name)
        rebuild_entity Database::SkillOrm.first(section_type: name)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Skill.new(
          id: db_record.id,
          name: db_record.name,
          experience: db_record.experience,
          type: db_record.type
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_skill|
          Skills.rebuild_entity(db_skill)
        end
      end

      def self.find_or_create(entity)
        Database::SkillOrm.find_or_create(entity.to_attr_hash)
      end
    end
  end
end
