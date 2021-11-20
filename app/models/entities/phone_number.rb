# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module Jobify
  module Entity
    # Domain Entity for any phone number
    class Phone < Dry::Struct
      include Dry.Types

      attribute :id,     Integer.optional
      attribute :number, String.optional

      def to_attr_hash
        to_hash.reject { |key, _| [:id].include? key }
      end
    end
  end
end
