# frozen_string_literal: true

module Jobify
  module Repository
    # Repository for Links
    class Links
      def self.find_id(id)
        rebuild_entity Database::LinkOrm.first(id: id)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Link.new(
          id: db_record.id,
          url: db_record.url
        )
      end
    end
  end
end
