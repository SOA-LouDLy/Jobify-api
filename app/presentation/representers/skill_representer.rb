# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module Jobify
  module Representer
    class Skill < Roar::Decorator
      include Roar::JSON

      property :name
      property :experience
      property :type
    end
  end
end
