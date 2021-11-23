# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

module Jobify
  module Entity
    # Domain entity for any work
    class Work < Dry::Struct
      include Dry.Types

      attribute :id,                      Integer.optional
      attribute :job_title,               String.optional
      attribute :organization,            String.optional
      attribute :formatted_location,      String.optional
      attribute :country,                 String.optional
      attribute :raw_location,            String.optional
      attribute :starting_date,           String.optional
      attribute :end_date,                String.optional
      attribute :months_in_position,      Integer.optional
      attribute :description,             String.optional

      def to_attr_hash
        to_hash.reject { |key, _| [:id].include? key }
      end
    end
  end
end
