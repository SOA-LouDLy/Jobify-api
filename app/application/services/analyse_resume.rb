# frozen_string_literal: true

require 'dry/monads'

module Jobify
  module Service
    # Transaction to analyse a resume
    class AnalyseResume
      include Dry::Transaction
      step :retrieve_resume
      step :analyse_resume

      private

      NO_RESUME_ERR = 'Resume not found'
      DB_ERR = 'Having trouble accessing the database'
      ANALYSIS_ERR = 'Could not analyse that resume'

      def retrieve_resume(input)
        input[:resume] = Repository::For.klass(Entity::Resume)
          .find_full_resume(input[:identifier])
        if input[:resume]
          Success(input)
        else
          Failure(Response::ApiResult.new(status: :not_found, message: NO_RESUME_ERR))
        end
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR))
      end

      def analyse_resume(input)
        input[:analysis] = Mapper::Analysis.new(input[:resume]).analysis
        Response::ResumeAnalysis.new(input[:resume], input[:analysis])
          .then do |analysis|
            Success(Response::ApiResult.new(status: :ok, message: analysis))
          end
      rescue StandardError
        Failure(Response::ApiResult.new(status: :not_found, message: ANALYSIS_ERR))
      end
    end
  end
end
