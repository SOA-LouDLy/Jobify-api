# frozen_string_literal: true

require 'vcr'
require 'webmock'

# Setting up VCR
module VcrHelper
  CASSETTES_FOLDER = 'spec/fixtures/cassettes'
  RESUME_CASSETTE = 'resume_api'

  def self.setup_vcr
    VCR.configure do |c|
      c.cassette_library_dir = CASSETTES_FOLDER
      c.hook_into :webmock
      c.ignore_localhost = true
    end
  end

  def self.configure_vcr_for_resume
    VCR.configure do |c|
      c.filter_sensitive_data('<RESUME_TOKEN>') { RESUME_TOKEN }
      c.filter_sensitive_data('<RESUME_TOKEN_ESC>') { CGI.escape(RESUME_TOKEN) }
    end

    VCR.insert_cassette(
      RESUME_CASSETTE,
      record: :new_episodes,
      match_requests_on: %i[method uri headers]
    )
  end

  def self.eject_vcr
    VCR.eject_cassette
  end
end
