# frozen_string_literal: true

require 'dry/monads'

module Jobify
  module Service
    # Retrieves array of all listed resume entities
    class ListResumes
      include Dry::Transaction

      step :validate_list
      step :retrieve_resumes

      private

      DB_ERR = 'Cannot access database'

      def validate_list(input)
        list_request = input[:list_request].call
        if list_request.success?
          Success(input.merge(list: list_request.value!))
        else
          Failure(list_request.failure)
        end
      end

      def retrieve_resumes(input)
        Repository::For.klass(Entity::Resume).find_full_identifiers(input[:list])
          .then { |resumes| Response::ResumesList.new(resumes) }
          .then { |list| Response::ApiResult.new(status: :ok, message: list) }
          .then { |result| Success(result) }
      rescue StandardError
        Failure(
          Response::ApiResult.new(status: :internal_error, message: DB_ERR)
        )
      end
    end
  end
end
