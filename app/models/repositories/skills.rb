# frozen_string_literal: true

module Jobify
  module Repository
    # Repository for Skills
    class Skills
      def self.find_id(id)
        rebuild_entity Database::SkillOrm.first(id: id)
      end

      def self.find_name(title)
        rebuild_entity Database::SKillOrm.first(title: title)
      end

      def self.find_all(title)
        skill_database = Database::SkillOrm
                         .left_join(:jobs, id: :skill_id)
                         .where(title: title)
                         .first
        rebuild_entity(skill_database)
      end

      def self.create(entity)
        Database::SkillOrm.find_or_create(entity.to_attr_hash)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Skill.new(
          name: db_record.name
        )
      end
    end
  end
end
