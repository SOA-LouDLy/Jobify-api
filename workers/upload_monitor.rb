# frozen_string_literal: true

module ResumeUpload
  # Infrastructure to upload while yielding progress
  module UploadMonitor
    UPLOAD_PROGRESS = {
      'STARTED'  => 15,
      'FINISHED' => 100
    }.freeze

    def self.starting_percent
      UPLOAD_PROGRESS['STARTED'].to_s
    end

    def self.finished_percent
      UPLOAD_PROGRESS['FINISHED'].to_s
    end

    def self.progress(line)
      CLONE_PROGRESS[first_word_of(line)].to_s
    end

    def self.first_word_of(line)
      line.match(/^[A-Za-z]+/).to_s
    end
  end
end
