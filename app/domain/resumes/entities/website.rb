# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module Jobify
  module Entity
    # Domain entity for any website
    class Website < Dry::Struct
      include Dry.Types

      attribute :id,      Integer.optional
      attribute :website, String.optional

      def to_attr_hash
        to_hash.reject { |key, _| [:id].include? key }
      end
    end
  end
end
