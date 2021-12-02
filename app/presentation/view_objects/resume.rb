# frozen_string_literal: true

module Views
  # View for a single resume entity
  class Resume
    def initialize(resume, index = nil)
      @resume = resume
      @index = index
    end

    def profession
      @resume.profession
    end

    def resume_link
      "format1/#{@resume.identifier}"
    end

    def index_str
      "resume[#{@index}]"
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

    def works
      @resume.works
    end
  end
end
