# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module Jobify
  module Entity
    # Domain entity for any email
    class Email < Dry::Struct
      include Dry.Types

      attribute :id,    Integer.optional
      attribute :email, String.optional

      def to_attr_hash
        to_hash.reject { |key, _| [:id].include? key }
      end
    end
  end
end
