# frozen_string_literal: true

require_relative 'resumes'
require_relative 'certifications'
require_relative 'educations'
require_relative 'emails'
require_relative 'languages'
require_relative 'phones'
require_relative 'sections'
require_relative 'skills'
require_relative 'websites'
require_relative 'works'
require_relative 'resume_files'

module Jobify
  module Repository
    # Finds the right repository for an entity object or class
    module For
      ENTITY_REPOSITORY = {
        Entity::Certification => Certifications,
        Entity::Email         => Emails,
        Entity::Language      => Languages,
        Entity::Phone         => Phones,
        Entity::Section       => Sections,
        Entity::Skill         => Skills,
        Entity::Website       => Websites,
        Entity::Work          => Works,
        Entity::Resume        => Resumes,
        Entity::ResumeFile    => ResumeFiles
      }.freeze

      def self.klass(entity_klass)
        ENTITY_REPOSITORY[entity_klass]
      end

      def self.entity(entity_object)
        ENTITY_REPOSITORY[entity_object.class]
      end
    end
  end
end
