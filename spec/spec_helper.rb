# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'yaml'
require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'
require './app/infrastructure/gateways_affinda/local_resume_api'
require 'curb'
require_relative '../init'

FILE = 'app/models/resume.pdf'
CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
RESUME_TOKEN = CONFIG['RESUME_TOKEN']

GOOD = YAML.safe_load(File.read('spec/fixtures/resumes_result.yml'))


CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'affinda_api'