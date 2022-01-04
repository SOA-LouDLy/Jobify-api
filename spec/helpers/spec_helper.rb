# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'
require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../../init'
FILE = 'spec/resume.pdf'
CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
RESUME_TOKEN = Jobify::App.config.RESUME_TOKEN
CORRECT = YAML.safe_load(File.read('spec/fixtures/resume_result.yml'))
DATA = CORRECT['data']
IDENTIFIER = 'zmIHbIQB'

def homepage
  Jobify::App.config.APP_HOST
end
