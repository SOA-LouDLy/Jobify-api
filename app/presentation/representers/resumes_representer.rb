# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'openstruct_with_links'
require_relative 'resume_representer'

module Jobify
  module Representer
    # Represents list of resumes for API output
    class ResumesList < Roar::Decorator
      include Roar::JSON

      collection :resumes, extend: Representer::Resume,
                           class: Representer::OpenStructWithLinks
    end
  end
end
