# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require_relative 'job'

module Jobify
  module Entity
    # ListJob Entity
    class ListJob < Dry::Struct
      include Dry.Types

      attribute :id, Integer.optional
      attribute :jobs, Strict::Array.of(Job)

      def to_attr_hash
        to_hash.reject { |key, _| [:id].include? key }
      end
    end
  end
end
