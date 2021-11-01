# frozen_string_literal: true

require_relative 'spec_helper'

describe 'Tests Career Jet API library' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock
    c.filter_sensitive_data('<API_KEY>') { JOB_TOKEN }
    c.filter_sensitive_data('<API_KEY_ESC>') { CGI.escape(JOB_TOKEN) }
  end
  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri headers]
  end
  after do
    VCR.eject_cassette
  end
  describe 'Job Information' do
    before do
      @job_data = Jobify::CareerJet::JobMapper.new(JOB_TOKEN).get_jobs(SKILL, LOCATION)
      @good_data = CORRECT.jobs.map do |x|
        Jobify::Entity::Job.new(
          date: x.date,
          url: x.url,
          title: x.title,
          description: x.description,
          company: x.company,
          locations: x.locations
        )
      end
    end
    it 'HAPPY: should return correct Job Info' do
      (0..@good_data.size - 1).each do |i|
        _(@job_data[i].locations).must_equal @good_data[i].locations
        _(@job_data[i].date).must_equal @good_data[i].date
        _(@job_data[i].company).must_equal @good_data[i].company
        _(@job_data[i].url).must_equal @good_data[i].url
        _(@job_data[i].title).must_equal @good_data[i].title
        _(@job_data[i].description).must_equal @good_data[i].description
      end
    end
  end
end
