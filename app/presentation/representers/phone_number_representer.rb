# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module Jobify
  module Representer
    class Phone < Roar::Decorator
      include Roar::JSON

      property :number
    end
  end
end
