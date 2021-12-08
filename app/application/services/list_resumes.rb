# frozen_string_literal: true

require 'dry/monads'

module Jobify
  module Service
    # Retrieves array of all listed resume entities
    class ListResumes
      include Dry::Monads::Result::Mixin

      def call(resumes_list)
        resumes = Jobify::Repository::For.klass(Entity::Resume)
          .find_full_identifiers(resumes_list)
        Success(resumes)
      rescue StandardError
        Failure('Could not access database')
      end
    end
  end
end
