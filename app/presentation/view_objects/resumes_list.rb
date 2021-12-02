# frozen_string_literal: true

require_relative 'resume'

module Views
  # View for a a list of resumes entities
  class ResumesList
    def initialize(resumes)
      @resumes = resumes.map.with_index { |res, i| Resume.new(res, i) }
    end

    def each(&block)
      @resumes.each(&block)
    end

    def any?
      @resumes.any?
    end
  end
end
