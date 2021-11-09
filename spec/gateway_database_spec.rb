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
        @job_data = Jobify::CareerJet::JobMapper.new(JOB_TOKEN).get_jobs(SKILL, LOCATION)
        

          @rebuilt = Jobify::Repository::For.entity(@job_data).create(@job_data)


          it 'HAPPY: should return correct Job Info' do
            (0..@rebuilt.size - 1).each do |i|
              _(@job_data[i].locations).must_equal @rebuilt[i].locations
              _(@job_data[i].date).must_equal @rebuilt[i].date
              _(@job_data[i].company).must_equal @rebuilt[i].company
              _(@job_data[i].url).must_equal @rebuilt[i].url
              _(@job_data[i].title).must_equal @rebuilt[i].title
              _(@job_data[i].description).must_equal @rebuilt[i].description
            end
          end


    end
  end
end