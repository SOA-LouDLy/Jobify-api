# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

module Jobify
  module Entity
    # Domain entity for any section
    class Section < Dry::Struct
      include Dry.Types

      attribute :id,                      Integer.optional
      attribute :section_type,            String.optional
      attribute :text,                    String.optional

      def to_attr_hash
        to_hash.reject { |key, _| [:id].include? key }
      end
    end
  end
end
