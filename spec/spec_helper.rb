# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'
require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../init'
FILE = 'lib/resume.pdf'
CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
RESUME_TOKEN = CONFIG['RESUME_TOKEN']
CORRECT = YAML.safe_load(File.read('spec/fixtures/resume_results.yml'))
