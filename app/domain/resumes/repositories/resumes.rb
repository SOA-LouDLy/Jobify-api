# frozen_string_literal: true

require_relative 'certifications'
require_relative 'educations'
require_relative 'emails'
require_relative 'phones'
require_relative 'sections'
require_relative 'skills'
require_relative 'languages'
require_relative 'websites'
require_relative 'works'

module Jobify
  module Repository
    # Repository for Job Entities
    class Resumes
      @data = Sequel[:resumes][:resume_orm_id]
      def self.all
        Database::ResumeOrm.all.map { |db_resume| rebuild_entity(db_resume) }
      end

      def self.find_full_resume(identifier)
        db_resume = Jobify::Database::ResumeOrm
          .left_join(:resumes_certifications, resume_orm_id: @data)
          .left_join(:resumes_educations, resume_orm_id: @data)
          .left_join(:emails, resume_orm_id: @data)
          .left_join(:phones, resume_orm_id: @data)
          .left_join(:resumes_sections, resume_orm_id: @data)
          .left_join(:resumes_skills, resume_orm_id: @data)
          .left_join(:resumes_languages, resume_orm_id: @data)
          .left_join(:resumes_websites, resume_orm_id: @data)
          .left_join(:works, resume_orm_id: @data)
          .where(Sequel.lit("`resumes`.`identifier` = '#{identifier}'"))
          .first
        rebuild_entity(db_resume)
      end

      def self.find(entity)
        find_identifier(entity.identifier)
      end

      def self.find_identifier(identifier)
        db_resume = Database::ResumeOrm.first(identifier: identifier)
        rebuild_entity(db_resume)
      end

      def self.find_id(id)
        db_resume = Database::ResumeOrm.first(id: id)
        rebuild_entity(db_resume)
      end

      def self.create(entity)
        raise 'Resume already exists' if find(entity)

        db_resume = PersistResume.new(entity).call
        rebuild_entity(db_resume)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Resume.new(
          db_record.to_hash.merge(
            id: db_record.id,
            certifications: Certifications.rebuild_many(db_record.certifications),
            education: Educations.rebuild_many(db_record.education),
            emails: Emails.rebuild_many(db_record.emails),
            phone_numbers: Phones.rebuild_many(db_record.phone_numbers),
            sections: Sections.rebuild_many(db_record.sections),
            skills: Skills.rebuild_many(db_record.skills),
            languages: Languages.rebuild_many(db_record.languages),
            websites: Websites.rebuild_many(db_record.websites),
            works: Works.rebuild_many(db_record.works)
          )
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_resume|
          Resumes.rebuild_entity(db_resume)
        end
      end

      # Helper class to persist resume and its fields
      class PersistResume
        def initialize(entity)
          @entity = entity
        end

        def create_resume
          Database::ResumeOrm.create(@entity.to_attr_hash)
        end

        def call
          # call_certifications
          create_resume.tap do |db_resume|
            missing = MissingEntities.new(@entity, db_resume)
            missing.certifications
            missing.educations
            missing.emails
            missing.languages
            missing.phones
            missing.sections
            missing.skills
            missing.works
          end
        end

        # Class for adding the missing entities to Resume Entity
        class MissingEntities
          def initialize(entity, db)
            @entity = entity
            @db_resume = db
          end

          def certifications
            @entity.certifications.each do |certification|
              @db_resume.add_certification(Certifications.find_or_create(certification))
            end
          end

          def educations
            @entity.education.each do |education|
              @db_resume.add_education(Educations.find_or_create(education))
            end
          end

          def emails
            @entity.emails.each do |email|
              @db_resume.add_email(Emails.find_or_create(email))
            end
          end

          def phones
            @entity.phone_numbers.each do |phone|
              @db_resume.add_phone_number(Phones.find_or_create(phone))
            end
          end

          def sections
            @entity.sections.each do |section|
              @db_resume.add_section(Sections.find_or_create(section))
            end
          end

          def skills
            @entity.skills.each do |skill|
              @db_resume.add_skill(Skills.find_or_create(skill))
            end
          end

          def languages
            @entity.languages.each do |language|
              @db_resume.add_language(Languages.find_or_create(language))
            end
          end

          def websites
            @entity.websites.each do |website|
              @db_resume.add_website(Websites.find_or_create(website))
            end
          end

          def works
            @entity.works.each do |work|
              @db_resume.add_work(Works.find_or_create(work))
            end
          end
        end
      end
    end
  end
end
