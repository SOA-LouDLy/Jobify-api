# frozen_string_literal: true

require 'sequel'

module Jobify
  module Database
    # Object Relational Mapper for Resume Entities
    class SkillOrm < Sequel::Model(:skills)
      many_to_many :resumes,
                   class: :'Jobify::Database::ResumeOrm',
                   join_table: :resumes_skills,
                   left_key: :skill_id, right_key: :resume_orm_id

      plugin :timestamps, update_on_create: true

      def self.find_or_create(skill_info)
        create(skill_info)
      end
    end
  end
end
