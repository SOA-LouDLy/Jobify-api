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

      # WHEN: we request a list of all watched resumes
      list_request = Jobify::Request::EncodedResumeList
        .to_request([resume.identifier])
      result = Jobify::Service::ListResumes.new.call(list_request: list_request)

      # THEN: we should see our resume in the resulting list
      _(result.success?).must_equal true
      list = result.value!.message
      _(list.resumes.first.identifier).must_equal db_resume.identifier
    end

    it 'HAPPY: should not return resumes that are not being watched' do
      # GIVEN: a valid resume exists locally but is not being watched
      resume = Jobify::Affinda::ResumeMapper.new(RESUME_TOKEN)
        .resume(FILE)
      Jobify::Repository::For.entity(resume)
        .create(resume)

      # WHEN: we request a list of all watched resumes
      list_request = Jobify::Request::EncodedResumeList
        .to_request([])
      result = Jobify::Service::ListResumes.new.call(list_request: list_request)

      # THEN: it should return an empty list
      _(result.success?).must_equal true
      list = result.value!.message
      _(list.resumes).must_equal []
    end

    it 'SAD: should not watched resumes if they are not loaded' do
      # GIVEN: we are watching a resume that does not exist locally
      list_request = Jobify::Request::EncodedResumeList
        .to_request([IDENTIFIER])

      # WHEN: we request a list of all watched resumes
      result = Jobify::Service::ListResumes.new.call(list_request: list_request)

      # THEN: it should return an empty list
      _(result.success?).must_equal true
      list = result.value!.message
      _(list.resumes).must_equal []
    end
  end
end
