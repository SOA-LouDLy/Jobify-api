# frozen_string_literal: true

module Jobify
  module Repository
    # Repository for Members
    class Phones
      def self.find_id(id)
        rebuild_entity Database::PhoneOrm.first(id: id)
      end

      def self.find_name(number)
        rebuild_entity Database::LanguageOrm.first(number: number)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Phone.new(
          id: db_record.id,
          number: db_record.number
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_phone|
          Phones.rebuild_entity(db_phone)
        end
      end

      def self.find_or_create(entity)
        Database::PhoneOrm.find_or_create(entity.to_attr_hash)
      end
    end
  end
end
