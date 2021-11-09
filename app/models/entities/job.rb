# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

module Jobify
  module Entity
    # Domain entity for any job
    class Job < Dry::Struct
      include Dry.Types
      attribute :id,            Integer.optional
      attribute :date,          Strict::String
      attribute :title,         Strict::String
      attribute :description,   Strict::String
      attribute :company,       Strict::String
      attribute :locations,     Strict::String
      attribute :url,           Strict::String

      def to_attr_hash
        to_hash.reject { |key, _| %i[id].include? key }
      end
    end
  end
end
