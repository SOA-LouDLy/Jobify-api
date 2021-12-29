# frozen_string_literal: true

require 'dry/transaction'

module Jobify
  module Service
    # Transaction to upload a resume to Affinda API to database
    class AddResume
      include Dry::Transaction

      # step :check_entered_file
      step :upload_resume
      step :store_resume

      private

      DB_ERR_MSG = 'Having trouble accessing the database'

      def upload_resume(input)
        resume = resume_from_affinda(input)
        Success(resume)
      rescue StandardError => e
        Failure(Response::ApiResult.new(status: :not_found, message: e.to_s))
      end

      def store_resume(input)
        resume = Repository::For.entity(input).create(input)
        Success(Response::ApiResult.new(status: :created, message: resume))
      rescue StandardError => e
        puts e.backtrace.join("\n")
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR_MSG))
      end

      def resume_from_affinda(input)
        Affinda::ResumeMapper
          .new(App.config.RESUME_TOKEN)
          .resume(input)
      rescue StandardError
        raise 'Free parsing over'
      end
    end
  end
end
