# frozen_string_literal: true

require 'sequel'

module Jobify
  module Database
    # Object Relational Mapper for Resume Entities
    class SectionOrm < Sequel::Model(:sections)
      many_to_many :resumes,
                   class: :'Jobify::Database::ResumeOrm',
                   join_table: :resumes_sections,
                   left_key: :section_id, right_key: :resume_orm_id

      plugin :timestamps, update_on_create: true

      def self.find_or_create(section_info)
        create(section_info)
      end
      # first(section_type: section_info[:section_type]) ||
    end
  end
end
