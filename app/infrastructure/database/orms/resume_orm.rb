# frozen_string_literal: true

require 'sequel'

module Jobify
  module Database
    # Object Relational Mapper for Resume Entities
    class ResumeOrm < Sequel::Model(:resumes)
      many_to_many :certifications,
                   class: :'Jobify::Database::CertificationOrm',
                   join_table: :resumes_certifications,
                   left_key: :resume_orm_id, right_key: :certification_id

      many_to_many :education,
                   class: :'Jobify::Database::EducationOrm',
                   join_table: :resumes_educations,
                   left_key: :resume_orm_id, right_key: :education_id

      one_to_many :emails,
                  class: :'Jobify::Database::EmailOrm',
                  key: :resume_orm_id

      one_to_many :phone_numbers,
                  class: :'Jobify::Database::PhoneOrm',
                  key: :resume_orm_id

      many_to_many :sections,
                   class: :'Jobify::Database::SectionOrm',
                   join_table: :resumes_sections,
                   left_key: :resume_orm_id, right_key: :section_id

      many_to_many :skills,
                   class: :'Jobify::Database::SkillOrm',
                   join_table: :resumes_skills,
                   left_key: :resume_orm_id, right_key: :skill_id

      many_to_many :languages,
                   class: :'Jobify::Database::LanguageOrm',
                   join_table: :resumes_languages,
                   left_key: :resume_orm_id, right_key: :language_id

      many_to_many :websites,
                   class: :'Jobify::Database::WebsiteOrm',
                   join_table: :resumes_websites,
                   left_key: :resume_orm_id, right_key: :website_id

      one_to_many :works,
                  class: :'Jobify::Database::WorkOrm',
                  key: :resume_orm_id

      plugin :timestamps, update_on_create: true
    end
  end
end
