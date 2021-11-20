# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module Jobify
  module Entity
    # Domain entity for any education
    class Education < Dry::Struct
      include Dry.Types

      attribute :id,                     Integer.optional
      attribute :organization,           String.optional
      attribute :accreditation,          String.optional
      attribute :grade,                  String.optional
      attribute :formatted_location,     String.optional
      attribute :raw_location,           String.optional
      attribute :starting_date,          String.optional
      attribute :end_date,               String.optional

      def to_attr_hash
        to_hash.reject { |key, _| [:id].include? key }
      end
    end
  end
end
