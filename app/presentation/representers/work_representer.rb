# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module Jobify
  module Representer
    class Work < Roar::Decorator
      include Roar::JSON

      property :job_title
      property :organization
      property :country
      property :raw_location
      property :starting_date
      property :end_date
      property :months_in_position
      property :description
    end
  end
end
