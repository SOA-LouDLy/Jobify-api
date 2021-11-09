# frozen_string_literal: false

require_relative 'spec_helper'
require_relative 'helpers/vcr_helper'
require_relative 'helpers/database_helper'

describe 'Integration Tests of CareerJet API and Database' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_job
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store job' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should be able to save project from CareerJet to database' do
      job_data = Jobify::CareerJet::ListJobMapper.new(JOB_TOKEN).get_jobs(SKILL, LOCATION)
      rebuilt = Jobify::Repository::For.entity(job_data).create(job_data)

      job_data.jobs.each.with_index do |job, i|
        _(rebuilt[i].locations).must_equal job.locations
        _(rebuilt[i].date).must_equal job.date
        _(rebuilt[i].company).must_equal job.company
        _(rebuilt[i].url).must_equal job.url
        _(rebuilt[i].title).must_equal job.title
        _(rebuilt[i].description).must_equal job.description
      end
    end
  end
end
