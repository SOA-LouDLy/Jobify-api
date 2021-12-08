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

      def upload_resume(input, api: Jobify::Affinda::Api)
        resume = resume_from_affinda(input, api)
        Success(resume)
      rescue StandardError => e
        Failure(e.to_s)
      end

      def store_resume(input)
        resume = Repository::For.entity(input).create(input)
        Success(resume)
      rescue StandardError => e
        puts e.backtrace.join("\n")
        Failure('Having trouble accessing the database')
      end

      def resume_from_affinda(input, api)
        Affinda::ResumeMapper
          .new(App.config.RESUME_TOKEN, api)
          .resume(input)
      rescue StandardError
        raise 'Free parsing over'
      end
    end
  end
end
