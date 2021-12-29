# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'
require_relative 'education_representer'
require_relative 'skill_representer'
require_relative 'work_representer'
require_relative 'certification_representer'
require_relative 'email_representer'
require_relative 'phone_number_representer'
require_relative 'language_representer'
require_relative 'website_representer'

# Represents essential resume information for API output
module Jobify
  module Representer
    # Represent a Resume entity as Json
    class Resume < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer

      property :identifier
      property :birth
      property :formatted_location
      property :location
      property :country
      property :state
      property :name
      property :objective
      property :summary
      property :linkedin
      property :total_experience
      property :profession

      collection :certifications, extend: Representer::Certification, class: OpenStruct
      collection :education, extend: Representer::Education, class: OpenStruct
      collection :emails, extend: Representer::Email, class: OpenStruct
      collection :phone_numbers, extend: Representer::Phone, class: OpenStruct
      collection :skills, extend: Representer::Skill, class: OpenStruct
      collection :languages, extend: Representer::Language, class: OpenStruct
      collection :works, extend: Representer::Work, class: OpenStruct

      link :self do
        "#{App.config.API_HOST}/api/v1/resumes/#{resume_identifier}"
      end

      private

      def resume_identifier
        represented.identifier
      end
    end
  end
end
