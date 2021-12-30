# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'

require 'ostruct'

describe 'AddResume Service Integration Test' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_resume
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Analyse a Resume' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should return resumes that are being watched' do
      # GIVEN: a valid resume exists locally and is being watched
      resume = Jobify::Affinda::ResumeMapper.new(RESUME_TOKEN)
        .resume(FILE)
      db_resume = Jobify::Repository::For.entity(resume)
        .create(resume)

      watched_list = [resume.identifier]

      # WHEN: we request a list of all watched resumes
      result = Jobify::Service::ListResumes.new.call(watched_list)

      # THEN: we should see our resume in the resulting list
      _(result.success?).must_equal true
      resumes = result.value!
      _(resumes[0].identifier).must_equal db_resume.identifier
    end

    it 'HAPPY: should not return resumes that are not being watched' do
      # GIVEN: a valid resume exists locally but is not being watched
      resume = Jobify::Affinda::ResumeMapper.new(RESUME_TOKEN, Jobify::Affinda::LocalApi)
        .resume(FILE)
      Jobify::Repository::For.entity(resume)
        .create(resume)

      watched_list = []

      # WHEN: we request a list of all watched resumes
      result = Jobify::Service::ListResumes.new.call(watched_list)

      # THEN: it should return an empty list
      _(result.success?).must_equal true
      resumes = result.value!
      _(resumes).must_equal []
    end

    it 'SAD: should not watched resumes if they are not loaded' do
      # GIVEN: we are watching a resume that does not exist locally
      watched_list = [IDENTIFIER]

      # WHEN: we request a list of all watched resumes
      result = Jobify::Service::ListResumes.new.call(watched_list)

      # THEN: it should return an empty list
      _(result.success?).must_equal true
      resumes = result.value!
      _(resumes).must_equal []
    end
  end
end
