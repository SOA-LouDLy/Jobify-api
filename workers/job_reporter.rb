# frozen_string_literal: true

require_relative 'progress_publisher'

module ResumeUpload
  # Reports job progress to client
  class JobReporter
    attr_accessor :id

    def initialize(request_json, config)
      upload_request = Jobify::Representer::UploadRequest
        .new(OpenStruct.new)
        .from_json(request_json)

      @id = upload_request.id
      @publisher = ProgressPublisher.new(config, upload_request.request_id)
    end

    def report(msg)
      @publisher.publish msg
    end

    def report_each_second(seconds, &operation)
      seconds.times do
        sleep(1)
        report(operation.call)
      end
    end
  end
end
