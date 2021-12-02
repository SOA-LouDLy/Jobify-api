# frozen_string_literal: true

module Views
  # View for a single resume entity
  class ResumeAnalysis
    SMILEYS = {
      0 => '🙌',
      1 => '😇',
      2 => '🙂',
      3 => '😕',
      4 => '👎'

    }.freeze

    def initialize(resume, analysis, index = nil)
      @resume = Resume.new(resume)
      @analysis = analysis
      @index = index
    end

    def score
      @analysis.split("\n").last.to_i
    end

    def scoring_message
      if score >= 90
        SMILEYS[0]
      elsif score >= 80 && score < 90
        SMILEYS[1]
      elsif score >= 70 && score < 80
        SMILEYS[2]
      elsif score >= 60 && score < 70
        SMILEYS[3]
      else
        SMILEYS[4]
      end
    end

    def splitting
      @analysis.split("\n")[0..-2]
    end

    def identifier
      @resume.identifier
    end

    def certifications
      @resume.certifications
    end

    def birth
      @resume.birth
    end

    def education
      @resume.education
    end

    def emails
      @resume.emails
    end

    def formatted_location
      @resume.formatted_location
    end

    def location
      @resume.location
    end

    def country
      @resume.country
    end

    def state
      @resume.state
    end

    def name
      @resume.name
    end

    def objective
      @resume.objective
    end

    def phone_numbers
      @resume.phone_numbers
    end

    def sections
      @resume.sections
    end

    def skills
      @resume.skills
    end

    def languages
      @resume.languages
    end

    def summary
      @resume.summary
    end

    def websites
      @resume.websites
    end

    def linkedin
      @resume.linkedin
    end

    def total_experience
      @resume.total_experience
    end

    def profession
      @resume.profession
    end

    def works
      @resume.works
    end
  end
end
