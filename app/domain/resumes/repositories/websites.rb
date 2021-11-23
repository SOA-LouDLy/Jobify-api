# frozen_string_literal: true

module Jobify
  module Repository
    # Repository for Members
    class Websites
      def self.find_id(id)
        rebuild_entity Database::WebsiteOrm.first(id: id)
      end

      def self.find_name(name)
        rebuild_entity Database::WebsiteOrm.first(website: name)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Website.new(
          id: db_record.id,
          website: db_record.website
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_website|
          Websites.rebuild_entity(db_website)
        end
      end

      def self.find_or_create(entity)
        Database::WebsiteOrm.find_or_create(entity.to_attr_hash)
      end
    end
  end
end
