# frozen_string_literal: true

require 'dry/transaction'

module Jobify
  module Service
    # Transaction to process a resume
    class AddResume
      include Dry::Transaction

      # step :check_entered_file
      step :store_resume_file
      step :request_posting_worker
      # step :reify_resume
      # step :store_resume

      private

      DB_ERR_MSG = 'Having trouble accessing the database'
      POST_ERR = 'Could not post this resume'
      PROCESSING_MSG = 'Processing the posting of request'
      DB_MSG = 'Could not persist resume'
      QUEUE_ERR = 'Queue is unreachable'

      def store_resume_file(input)
        input[:file] = persist_resume_file(input[:resume])
        if input[:file]
          Success(input)
        else
          Failure(Response::ApiResult.new(status: :internal_error, message: DB_MSG))
        end
      rescue StandardError => e
        puts e.backtrace.join("\n")
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR_MSG))
      end

      def request_posting_worker(input)
        Messaging::Queue.new(App.config.UPLOAD_QUEUE_URL,
                             App.config).send(upload_request_json(input))

        Response::UploadRequest.new(input[:file].id.to_s, input[:request_id])
          .then do |uploading|
            Success(Response::ApiResult.new(status: :ok, message: uploading))
          end
      rescue StandardError => e
        print_error(e)
        Failure(Response::ApiResult.new(status: :internal_error, message: QUEUE_ERR))
      end

      # Support method for steps

      def persist_resume_file(input)
        resume_file = Affinda::ResumeFileMapper.build_entity(input['pdf64'])
        Repository::For.entity(resume_file).create(resume_file)
      end

      def print_error(error)
        puts [error.inspect, error.backtrace].flatten.join("\n")
      end

      def upload_request_json(input)
        Response::UploadRequest.new(input[:file].id.to_s, input[:request_id])
          .then { Representer::UploadRequest.new(_1) }
          .then(&:to_json)
      end
    end
  end
end
