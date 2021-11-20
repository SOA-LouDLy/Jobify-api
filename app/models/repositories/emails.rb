# frozen_string_literal: true

module Jobify
  module Repository
    # Repository for Members
    class Emails
      def self.find_id(id)
        rebuild_entity Database::EmailOrm.first(id: id)
      end

      def self.find_name(name)
        rebuild_entity Database::EmailOrm.first(email: name)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Email.new(
          id: db_record.id,
          email: db_record.email
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_email|
          Emails.rebuild_entity(db_email)
        end
      end

      def self.find_or_create(entity)
        Database::EmailOrm.find_or_create(entity.to_attr_hash)
      end
    end
  end
end
