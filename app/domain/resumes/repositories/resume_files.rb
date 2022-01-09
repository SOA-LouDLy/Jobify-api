# frozen_string_literal: true

module Jobify
  module Repository
    # Repository for Resume Encoded
    class ResumeFiles
      def self.find_id(id)
        rebuild_entity Database::ResumeFileOrm.first(id: id)
      end

      def self.update_result(id, data)
        Jobify::Database::ResumeFileOrm
          .where(id: id)
          .update(result: data)
        db_resume = Jobify::Database::ResumeFileOrm.find(id: id)
        rebuild_entity(db_resume)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::ResumeFile.new(
          id: db_record.id,
          content: db_record.content,
          result: db_record.result
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_resume_encoded|
          ResumeFiles.rebuild_entity(db_resume_encoded)
        end
      end

      def self.create(entity)
        Database::ResumeFileOrm.find_or_create(entity.to_attr_hash)
      end
    end
  end
end
