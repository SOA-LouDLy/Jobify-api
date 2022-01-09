# frozen_string_literal: false

module Jobify
  # Mapper to transform section to a section entity
  module Affinda
    # Data Mapper: Section -> Section entity
    class ResumeMapper
      def initialize(cv_token, gateway_class = Affinda::Api)
        @key = cv_token
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@key)
      end

      def resume(file)
        @gateway.resume(file)
        # build_entity(data)
      end

      def build_entity(data)
        DataMapper.new(data).build_entity
      end

      def self.build_entity(data)
        DataMapper.new(data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(resume)
          @data = resume['data']
          @identifier = resume
        end

        def build_entity
          Jobify::Entity::Resume.new(
            id: nil,
            certifications: certifications,
            birth: birth,
            education: education,
            emails: emails,
            formatted_location: formatted_location,
            location: location,
            country: country,
            state: state,
            name: name,
            objective: objective,
            phone_numbers: phone_numbers,
            sections: sections,
            skills: skills,
            languages: languages,
            summary: summary,
            websites: websites,
            linkedin: linkedin,
            total_experience: total_experience,
            profession: profession,
            works: works,
            identifier: identifier
          )
        end

        def certifications
          @data['certifications']&.map { |certification| CertificationMapper.build_entity(certification) }
        end

        def birth
          @data['dateOfBirth']
        end

        def education
          @data['education']&.map { |education| EducationMapper.build_entity(education) }
        end

        def emails
          @data['emails']&.map { |email| EmailMapper.build_entity(email) }
        end

        def formatted_location
          @data['location']['formatted'] unless @data['location'].nil?
        end

        def location
          @data['location']['rawInput'] unless @data['location'].nil?
        end

        def country
          @data['country']
        end

        def state
          @data['state']
        end

        def name
          @data['name']['raw'] unless @data['name'].nil?
        end

        def objective
          @data['objective']
        end

        def phone_numbers
          @data['phoneNumbers']&.map { |phone| PhoneMapper.build_entity(phone) }
        end

        def sections
          @data['sections']&.map { |section| SectionMapper.build_entity(section) }
        end

        def skills
          @data['skills']&.map { |skill| SkillMapper.build_entity(skill) }
        end

        def languages
          @data['languages']&.map { |language| LanguageMapper.build_entity(language) }
        end

        def summary
          @data['summary']
        end

        def websites
          @data['websites']&.map { |website| WebsiteMapper.build_entity(website) }
        end

        def linkedin
          @data['linkedin']
        end

        def total_experience
          @data['totalYearsExperience']
        end

        def profession
          @data['profession']
        end

        def works
          @data['workExperience']&.map { |work| WorkExperienceMapper.build_entity(work) }
        end

        def identifier
          @identifier['meta']['identifier'] unless @identifier['meta'].nil?
        end
      end
    end
  end
end
