# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

module Jobify
  module Entity
    # Domain entity for any skill
    class Skill < Dry::Struct
      include Dry.Types

      attribute :id,                    Integer.optional
      attribute :name,                  String.optional
      attribute :experience,            Integer.optional
      attribute :type,                  String.optional

      def to_attr_hash
        to_hash.reject { |key, _| [:id].include? key }
      end
    end
  end
end
