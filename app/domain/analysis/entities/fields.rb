# frozen_string_literal: true

module Jobify
  module Entity
    # Aggregate root for missing fields domain
    class Fields
      def initialize(resume)
        @resume = resume
        @score = 0
      end

      def major_field
        @score + 16
      end

      def minor_field
        @score + 5
      end

      def name
        @resume.name ? major_field : 0
      end

      def emails
        @resume.emails.count.positive? ? major_field : 0
      end

      def education
        @resume.education.count.positive? ? major_field : 0
      end

      def skills
        @resume.skills.count.positive? ? major_field : 0
      end

      def work_experience
        @resume.works.count.positive? ? major_field : 0
      end

      def language
        @resume.languages.count.positive? ? minor_field : 0
      end

      def linkedin
        @resume.linkedin ? minor_field : 0
      end

      def summary
        @resume.summary ? minor_field : 0
      end

      def location
        @resume.location ? minor_field : 0
      end

      def profession
        @resume.profession ? minor_field : 0
      end

      def education_missing_fields
        total = 0
        @resume.education&.each do |education|
          total -= 2 unless education.organization
          total -= 2 unless education.accreditation
          total -= 1 unless education.raw_location
          total -= 2 unless education.starting_date
          total -= 2 unless education.end_date
        end
        total
      end

      def work_missing_fields
        total = 0
        @resume.works&.each do |work|
          total -= 3 unless work.job_title
          total -= 1 unless work.formatted_location
          total -= 3 unless work.description
          total -= 2 unless work.starting_date
          total -= 2 unless work.end_date
        end
        total
      end

      def report
        Entity::Report.new(@resume, name + emails + education + skills + work_experience + language +
          linkedin + profession + summary + location + education_missing_fields + work_missing_fields).report
      end
    end
  end
end
