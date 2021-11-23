# frozen_string_literal: true

module Jobify
  module Entity
    # Aggregate root for missing fields domain
    class Report
      def initialize(resume, score)
        @resume = resume
        @score = score
      end

      def generate_major_error(text)
        "#{text} missing from Resume\n"
      end

      def generate_minor_error(text)
        "Consider adding #{text} to Resume\n"
      end

      def name
        generate_major_error('Name') unless @resume.name
      end

      def emails
        generate_major_error('Emails') unless @resume.emails.count.positive?
      end

      def education
        generate_major_error('Education') unless @resume.education.count.positive?
      end

      def skills
        generate_major_error('Skills') unless @resume.skills.count.positive?
      end

      def work_experience
        generate_major_error('Work Experience') unless @resume.works.count.positive?
      end

      def language
        generate_minor_error('Language') unless @resume.languages.count.positive?
      end

      def linkedin
        generate_minor_error('LinkedIn') unless @resume.linkedin
      end

      def summary
        generate_minor_error('Summary') unless @resume.summary
      end

      def location
        generate_minor_error('Location') unless @resume.location
      end

      def profession
        generate_minor_error('Profession') unless @resume.profession
      end

      def education_missing_fields
        message = ''
        @resume.education&.each do |education|
          message += generate_minor_error("Education's organization") unless education.organization
          message += generate_minor_error("Education's accreditation") unless education.accreditation
          message += generate_minor_error("Education's Location") unless education.raw_location
          message += generate_minor_error("Education's starting date") unless education.starting_date
          message += generate_minor_error("Education's end date") unless education.end_date
        end
        message
      end

      def work_missing_fields
        message = ''
        @resume.works&.each do |work|
          message += generate_minor_error("Work's title") unless work.job_title
          message += generate_minor_error("Work's location") unless work.formatted_location
          message += generate_minor_error("Work's description") unless work.description
          message += generate_minor_error("Work's start") unless work.starting_date
          message += generate_minor_error("Work's title") unless work.end_date
        end
        message
      end

      def report
        "#{name}#{emails}#{education}#{skills}#{work_experience}#{language}#{linkedin}#{summary}#{location}
        #{education_missing_fields}#{work_missing_fields}#{@score}"
      end
    end
  end
end
