# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

require_relative 'education'
require_relative 'section'
require_relative 'skill'
require_relative 'work'
require_relative 'certification'
require_relative 'email'
require_relative 'phone_number'
require_relative 'language'
require_relative 'website'

module Jobify
  module Entity
    # Domain entity for anu resume
    class Resume < Dry::Struct
      include Dry.Types

      attribute :id,                          Integer.optional
      attribute :certifications,              Array.of(Certification).optional
      attribute :birth,                       String.optional
      attribute :education,                   Array.of(Education).optional
      attribute :emails,                      Array.of(Email).optional
      attribute :formatted_location,          String.optional
      attribute :location,                    String.optional
      attribute :country,                     String.optional
      attribute :state,                       String.optional
      attribute :name,                        String.optional
      attribute :objective,                   String.optional
      attribute :phone_numbers,               Array.of(Phone).optional
      attribute :sections,                    Array.of(Section).optional
      attribute :skills,                      Array.of(Skill).optional
      attribute :languages,                   Array.of(Language).optional
      attribute :summary,                     String.optional
      attribute :websites,                    Array.of(Website).optional
      attribute :linkedin,                    String.optional
      attribute :total_experience,            Integer.optional
      attribute :profession,                  String.optional
      attribute :works,                       Array.of(Work).optional
      attribute :identifier,                  Strict::String


      

      def to_attr_hash
        to_hash.reject do |key, _|
          %i[id certifications education emails phone_numbers sections
             skills languages websites works].include? key
        end
      end
    end
  end
end
