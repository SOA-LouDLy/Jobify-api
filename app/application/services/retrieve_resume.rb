# frozen_string_literal: true

require 'dry/transaction'

module Jobify
  module Service
    # Transaction to retrieve and rebuild a resume
    class RetrieveResume
      include Dry::Transaction

      step :retrieve_resume_content
      step :reify_resume
      step :store_resume

      private

      DB_ERR_MSG = 'Having trouble accessing the database'

      def retrieve_resume_content(input)
        content = resume_content(input)
        Success(content)
      rescue StandardError => e
        Failure(Response::ApiResult.new(status: :not_found, message: e.to_s))
      end

      def reify_resume(input)
        rebuilt = rebuild_resume(input)
        Success(rebuilt)
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

      # Support Methods to steps
      def resume_content(id)
        Jobify::Repository::For.klass(Jobify::Entity::ResumeFile)
          .find_id(id).result
      rescue StandardError
        raise 'DB error'
      end

      def rebuild_resume(input)
        Affinda::ResumeMapper.build_entity(JSON.parse(input))
      end
    end
  end
end
