# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module Jobify
  module Representer
    # Represents resume's report
    class Fields < Roar::Decorator
      include Roar::JSON

      property :report
    end
  end
end
