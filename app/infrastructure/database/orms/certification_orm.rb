# frozen_string_literal: true

require 'sequel'

module Jobify
  module Database
    # Object Relational Mapper for Resume Entities
    class CertificationOrm < Sequel::Model(:certifications)
      many_to_many :resumes,
                   class: :'Jobify::Database::ResumeOrm',
                   join_table: :resumes_certifications,
                   left_key: :certification_id, right_key: :resume_orm_id

      plugin :timestamps, update_on_create: true

      def self.find_or_create(certification_info)
        create(certification_info)
      end
    end
  end
end
