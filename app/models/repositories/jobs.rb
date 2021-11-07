# frozen_string_literal: true

module Jobify
  module Repository
    # Repository for Job Entities
    class Jobs
      def self.all
        Database::JobOrm.all.map { |db_job| rebuild_entity(db_job) }
      end

      def self.find_url(title, location)
        # SELECT * FROM `jobs` LEFT JOIN `links`
        # ON (`links`.`id` = `jobs`.`link_id`)
        # WHERE ((`title` = 'tile') AND (`locations` = 'location'))
        db_job = Database::JobOrm
                 .left_join(:links, id: :link_id)
                 .where(title: title, locations: location)
                 .first
        rebuild_entity(db_project)
      end

      def self.find_id(id)
        db_job = Database::JobOrm.first(id: id)
        rebuild_entity(db_job)
      end

      def self.rebuild_entity(db_job)
        return nil unless db_job

        Entity::Job.new(
          id: db_job.id,
          title: db_job.title,
          date: db_job.date,
          description: db_job.description,
          company: db_job.company,
          locations: db_job.locations,
          url: db_job.url
        )
      end
    end
  end
end
