# frozen_string_literal: true

require 'sequel'

module Jobify
  module Database
    # Object Relational Mapper for Resume Entities
    class EducationOrm < Sequel::Model(:educations)
      many_to_many :resumes,
                   class: :'Jobify::Database::ResumeOrm',
                   join_table: :resumes_educations,
                   left_key: :education_id, right_key: :resume_id

      plugin :timestamps, update_on_create: true

      def self.find_or_create(education_info)
        create(education_info)
      end
      # first(organization: education_info[:organization]) ||
    end
  end
end
