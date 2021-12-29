# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module Jobify
  module Representer
    class Certification < Roar::Decorator
      include Roar::JSON

      property :name
    end
  end
end
