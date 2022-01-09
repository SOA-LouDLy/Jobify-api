# frozen_string_literal: true

require_relative '../init'

require_relative 'upload_monitor'
require_relative 'job_reporter'
require 'figaro'
require 'shoryuken'

module ResumeUpload
  # Shoryuken worker class to upload resumes in parallel
  class Worker
    # Environment variables setup
    Figaro.application = Figaro::Application.new(
      environment: ENV['RACK_ENV'] || 'development',
      path: File.expand_path('config/secrets.yml')
    )
    Figaro.load
    def self.config() = Figaro.env

    Shoryuken.sqs_client = Aws::SQS::Client.new(
      access_key_id: config.AWS_ACCESS_KEY_ID,
      secret_access_key: config.AWS_SECRET_ACCESS_KEY,
      region: config.AWS_REGION
    )

    include Shoryuken::Worker
    Shoryuken.sqs_client_receive_message_opts = { wait_time_seconds: 20 }
    shoryuken_options queue: config.UPLOAD_QUEUE_URL, auto_delete: true

    def perform(_sqs_msg, request)
      # request is the id of the file in DB
      # Transaction Script
      puts request
      job = JobReporter.new(request, Worker.config)
      job.report(UploadMonitor.starting_percent)
      file = retrieve_resume_content(job.id)
      # retrieve_resume_content(job.id) do |line|
      #   job.report UploadMonitor.progress(line)
      # end

      temp_file = create_temp_file(file)
      resume = upload(temp_file)
      update_result(job.id, resume.to_json) do |line|
        job.report UploadMonitor.progress(line)
      end

      # Keep sending finished status to any latecoming subscribers
      job.report_each_second(5) { UploadMonitor.finished_percent }
    end

    def retrieve_resume_content(id)
      content = Jobify::Repository::For.klass(Jobify::Entity::ResumeFile)
        .find_id(id.to_i).content
      Base64.decode64(content)
    rescue StandardError => e
      puts e.backtrace.join("\n")
    end

    def create_temp_file(file)
      Tempfile.new(['', '.pdf'], encoding: 'ASCII-8BIT').tap { |f| f.write(file) }
    end

    def upload(input)
      Jobify::Affinda::ResumeMapper
        .new(Worker.config.RESUME_TOKEN)
        .resume(input)
    rescue StandardError
      raise 'Free parsing over'
    end

    def update_result(id, data)
      Jobify::Repository::For.klass(Jobify::Entity::ResumeFile)
        .update_result(id.to_i, data)
    rescue StandardError => e
      puts e.backtrace.join("\n")
    end
  end
end
