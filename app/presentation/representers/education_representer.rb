# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

# Represents education information for API output
module Jobify
  module Representer
    # Represent a Project entity as Json
    class Education < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer

      property :organization
      property :accreditation
      property :raw_location
      property :starting_date
      property :end_date
    end
  end
end
