# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module Jobify
  module Representer
    class Website < Roar::Decorator
      include Roar::JSON

      property :website
    end
  end
end
