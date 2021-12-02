# frozen_string_literal: true

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/database_helper'
require_relative '../../helpers/vcr_helper'
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
      it '(HAPPY) should not see resumes if none created' do
        # GIVEN: user is on the home page without any projects
        @browser.goto homepage

        # THEN: user should see basic headers, no projects and a welcome message
        _(@browser.h1(id: 'main_header').text).must_equal 'JOBIFY'
        _(@browser.form(id: 'show-formats').present?).must_equal true
        _(@browser.file_field(id: 'resume_upload').exists?).must_equal true
        _(@browser.button(id: 'cv-submit').present?).must_equal true
        _(@browser.table(id: 'resumes_table').exists?).must_equal false
      end

      it '(HAPPY) should not see projects they did not request' do
        # GIVEN: a resume exists in the database but user has not requested it
        resume = Jobify::Affinda::ResumeMapper
          .new(RESUME_TOKEN, Jobify::Affinda::LocalApi)
          .resume(FILE)
        Jobify::Repository::For.entity(resume).create(resume)

        # WHEN: user goes to the homepage
        @browser.goto homepage

        # THEN: they should not see any resumes
        _(@browser.table(id: 'resumes_table').exists?).must_equal false
      end
    end

    describe 'Add resume' do
      it '(HAPPY) should be able to upload a resume' do
        # GIVEN:  user is on the home page without any resume
        resume = Jobify::Affinda::ResumeMapper
          .new(RESUME_TOKEN, Jobify::Affinda::LocalApi)
          .resume(FILE)
        Jobify::Repository::For.entity(resume).create(resume)

        @browser.goto homepage

        # WHEN: they upload a resume and submit
        @browser.button(id: 'cv-submit').click

        # THEN: they should find themselves on the resume's page
        @browser.url.include? resume.identifier
      end

      describe 'Delete Resume' do
        it '(HAPPY) should be able to delete a requested resume' do
          # GIVEN: user has requested and created a single resume
          resume = Jobify::Affinda::ResumeMapper
            .new(RESUME_TOKEN, Jobify::Affinda::LocalApi)
            .resume(FILE)
          Jobify::Repository::For.entity(resume).create(resume)
          @browser.goto homepage
          @browser.button(id: 'cv-submit').click

          # WHEN: they revisit the homepage and delete the project
          @browser.goto homepage

          @browser.table(id: 'resumes_table').exists? ? @browser.button(id: 'resume[0].delete').click : false
          # @browser.button(id: 'resume[0].delete').click
          # THEN: they should not find any resume
          _(@browser.table(id: 'resumes_table').exists?).must_equal false
        end
      end

      describe 'Formats Page' do
        it '(HAPPY) should see resume format 1' do
          # GIVEN: a resume is uploaded
          resume = Jobify::Affinda::ResumeMapper
            .new(RESUME_TOKEN, Jobify::Affinda::LocalApi)
            .resume(FILE)

          Jobify::Repository::For.entity(resume).create(resume)

          # WHEN: user goes directly to the formats page
          @browser.goto "http://localhost:9000/formats/#{resume.identifier}"

          # THEN: they should see the resume formats details
          _(@browser.h1(id: 'second-heading').text).must_equal 'Beautify your Resume'
          _(@browser.p(id: 'first-p').text).must_equal 'Select one of those beautifully crafted formats below and have a stunning resume. New formats added every week.'
          _(@browser.img(id: 'first-image').exists?).must_equal true
          _(@browser.p(id: 'first-card-p').text).must_equal 'A fan-favorite template, loved by thousands and very elegant.'
          @browser.goto "http://localhost:9000/format1/#{resume.identifier}"
        end

        it '(HAPPY) should see resume format 2' do
          # GIVEN: a resume is uploaded
          resume = Jobify::Affinda::ResumeMapper
            .new(RESUME_TOKEN, Jobify::Affinda::LocalApi)
            .resume(FILE)

          Jobify::Repository::For.entity(resume).create(resume)

          # WHEN: user goes directly to the formats page
          @browser.goto "http://localhost:9000/formats/#{resume.identifier}"
          # THEN: they should see the resume formats details
          _(@browser.img(id: 'second-image').exists?).must_equal true
          _(@browser.p(id: 'second-card-p').text).must_equal 'Simple, straight to point and yet so powerful.'
          @browser.goto "http://localhost:9000/format2/#{resume.identifier}"
        end
      end
    end
  end
end
