# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module Jobify
  module Representer
    class Email < Roar::Decorator
      include Roar::JSON

      property :email
    end
  end
end
