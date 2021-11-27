# frozen_string_literal: true

require_relative 'helpers/spec_helper'
require_relative 'helpers/database_helper'
require_relative 'helpers/vcr_helper'
# require 'headless'
require 'webdrivers/chromedriver'
require 'watir'

describe 'Acceptance Tests' do
  before do
    DatabaseHelper.wipe_database
    # @headless = Headless.new
    @browser = Watir::Browser.new
  end

  after do
    @browser.close
    # @headless.destroy
  end

  describe 'Homepage' do
    describe 'Visit Home page' do
      it '(HAPPY) should not see resumes if none uploaded' do
        # GIVEN: user is on the home page without any projects
        @browser.goto homepage

        # THEN: user should see basic headers, no projects and a welcome message
        _(@browser.h1(id: 'main_header').text).must_equal 'Jobify'
        _(@browser.file_field(id: 'resume_upload').present?).must_equal true
        _(@browser.button(id: 'cv-submit').present?).must_equal true
        _(@browser.table(id: 'resumes_table').exists?).must_equal false

        # _(@browser.div(id: 'flash_bar_success').present?).must_equal true
        # _(@browser.div(id: 'flash_bar_success').text.downcase).must_include 'start'
      end

      it '(HAPPY) should not see projects they did not request' do
        # WHEN: user goes to the homepage
        @browser.goto homepage

        # THEN: they should not see any resumes
        _(@browser.table(id: 'resumes_table').exists?).must_equal false
      end
    end

    describe 'Add resume' do
      it '(HAPPY) should be able to request a project' do
        # GIVEN: user is on the home page without any projects
        @browser.goto homepage

        # WHEN: they add a project URL and submit

        @browser.file_field(id: 'resume_upload').set(FILE)
        @browser.button(id: 'cv-submit').click
      end

      it '(BAD) should not be able to add an invalid project URL' do
        # GIVEN: user is on the home page without any projects
        @browser.goto homepage

        # WHEN: they request a project with an invalid URL
        bad_file = 'foobar'
        @browser.file_field(id: 'resume_upload').set(bad_file)
        @browser.button(id: 'cv-submit').click

        # THEN: they should see a warning message
        # _(@browser.div(id: 'flash_bar_danger').present?).must_equal true
        # _(@browser.div(id: 'flash_bar_danger').text.downcase).must_include 'invalid'
      end
    end
  end
end
