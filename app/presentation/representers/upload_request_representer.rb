# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

# Represents essential Resume information for API output
module Jobify
  module Representer
    # Representer object for resume upload requests
    class UploadRequest < Roar::Decorator
      include Roar::JSON

      property :id
      property :request_id
    end
  end
end
