# frozen_string_literal: true

module Jobify
  module Repository
    # Repository for Jobs
    class Jobs
      def self.all
        Database::JobOrm.all.map { |job_db| rebuild_entity(job_db) }
      end

      def self.find_id(id)
        job_db = Database::JobOrm.first(id: id)
        rebuild_entity(job_db)
      end
    end
  end
end
