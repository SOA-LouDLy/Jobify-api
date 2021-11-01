# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative '../lib/job_api'

require 'careerjet/api_client'

SKILL = 'ruby'
LOCATION = 'london'
CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
JOB_TOKEN = CONFIG['API_KEY']

GOOD = YAML.safe_load(File.read('spec/fixtures/job_results.yml'), permitted_classes: [Careerjet::Mash, Hashie::Array])

describe 'Test Career Jet API' do
  before do
    @job_data = Jobify::CarrerjetApi.new(JOB_TOKEN).job(SKILL, LOCATION)
    @good_data = GOOD.jobs.map { |x| Jobify::Job.new(x) }
  end
  it 'HAPPY: should return correct Job Info' do
    (0..@good_data.size - 1).each do |i|
      _(@job_data[i].locations).must_equal @good_data[i].locations
      _(@job_data[i].date).must_equal @good_data[i].date
      _(@job_data[i].company).must_equal @good_data[i].company
      _(@job_data[i].url).must_equal @good_data[i].url
      _(@job_data[i].title).must_equal @good_data[i].title
    end
  end
end
