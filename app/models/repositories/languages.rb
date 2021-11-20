# frozen_string_literal: true

module Jobify
  module Repository
    # Repository for Members
    class Languages
      def self.find_id(id)
        rebuild_entity Database::LanguageOrm.first(id: id)
      end

      def self.find_name(name)
        rebuild_entity Database::LanguageOrm.first(email: name)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Language.new(
          id: db_record.id,
          name: db_record.name
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_language|
          Languages.rebuild_entity(db_language)
        end
      end

      def self.find_or_create(entity)
        Database::LanguageOrm.find_or_create(entity.to_attr_hash)
      end
    end
  end
end
