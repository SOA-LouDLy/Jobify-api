# frozen_string_literal: true

require 'sequel'

module Jobify
  module Database
    # Object Relational Mapper for Resume Entities
    class WorkOrm < Sequel::Model(:works)
      many_to_one :resume,
                  class: :'Jobify::Database::ResumeOrm'

      plugin :timestamps, update_on_create: true

      def self.find_or_create(work_info)
        create(work_info)
      end
      # first(job_title: work_info[:job_title]) ||
    end
  end
end
