# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

module Jobify
  module Entity
    # Domain entity for resume_encoded
    class ResumeFile < Dry::Struct
      include Dry.Types

      attribute :id,        Integer.optional
      attribute :content,   Strict::String
      attribute :result,    String.optional

      def to_attr_hash
        to_hash.reject { |key, _| [:id].include? key }
      end
    end
  end
end
