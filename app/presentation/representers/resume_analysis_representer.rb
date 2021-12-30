# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'resume_representer'
require_relative 'report_representer'

module Jobify
  module Representer
    class ResumeAnalysis < Roar::Decorator
      include Roar::JSON

      property :resume, extend: Representer::Resume, class: OpenStruct
      property :report, extend: Representer::Fields, class: OpenStruct
    end
  end
end
