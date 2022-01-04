# frozen_string_literal: true

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'
require_relative '../../helpers/database_helper'
require 'rack/test'
require 'base64'
require 'json'

require 'http'

def app
  Jobify::App
end

describe 'Test API routes' do
  include Rack::Test::Methods

  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_resume
    DatabaseHelper.wipe_database
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Root route' do
    it 'should successfully return root information' do
      get '/'
      _(last_response.status).must_equal 200

      body = JSON.parse(last_response.body)
      _(body['status']).must_equal 'ok'
      _(body['message']).must_include 'api/v1'
    end
  end

  describe 'Add resumes route' do
    it 'should be able to add a resume' do
      str = File.read(FILE)
      tmpfile = Tempfile.new.tap { |f| f << str }

      pdf_str = File.read(tmpfile)
      pdf_encoded = Base64.encode64(pdf_str)

      post 'api/v1/resumes', { 'pdf64' => pdf_encoded }.to_json, { 'CONTENT_TYPE' => 'application/json' }

      # puts JSON.parse last_response.body

      resume = JSON.parse last_response.body
      _(resume['education'][0]['organization']).must_equal 'Columbia University'
      _(resume['emails'][0]['email']).must_equal 'christoper.morgan@gmail.com'
      _(resume['formatted_location']).must_equal '6PQ, 177 Great Portland St, London W1W 5PQ, UK'
      _(resume['summary']).must_include 'Senior Web Developer'
      _(resume['total_experience']).must_equal 4
      _(resume['profession']).must_include 'Web'
      _(resume['name']).must_equal 'CHRISTOPHER MORGAN'
      _(resume['phone_numbers'][0]['number']).must_equal '+442076668555'
      _(resume['skills'].count).must_equal 17
      _(resume['languages'][0]['name']).must_equal 'Spanish'
      _(resume['works'].count).must_equal 1
      @identifier = _(resume['identifier'])

      res = Jobify::Representer::Resume.new(
        Jobify::Representer::OpenStructWithLinks.new
      ).from_json last_response.body
      _(res.links['self'].href).must_include '/api/v1/resumes'
    end
  end
  describe 'Get Resumes List' do
    it 'should successfully return resume lists' do
      resume_made = Jobify::Service::AddResume.new.call(FILE)
      identifier = resume_made.value!.message.identifier
      list = [identifier]
      encoded_list = Jobify::Request::EncodedResumeList.to_encoded(list)

      get "/api/v1/resumes?list=#{encoded_list}"
      _(last_response.status).must_equal 200
      response = JSON.parse(last_response.body)
      puts response
      resumes = response['resumes']
      _(resumes.count).must_equal 1
      resume = resumes.first
      _(resume['location']).must_equal '177 Great Portland Street, London W5W 6PQ'
      _(resume['country']).must_equal 'United States'
      _(resume['name']).must_equal 'CHRISTOPHER MORGAN'
      _(resume['summary']).must_include 'Web Developer'
      _(resume['certifications'][0].count).must_equal 1
      _(resume['education'][0]['organization']).must_equal 'Columbia University'
      _(resume['emails'][0]['email']).must_equal 'christoper.morgan@gmail.com'
      _(resume['phone_numbers'][0]['number']).must_equal '+442076668555'
      _(resume['works'].count).must_equal 1
      _(resume['works'][0]['job_title']).must_include 'Web'
      _(resume['works'][0]['organization']).must_include 'Luna'
      _(resume['works'][0]['country']).must_equal 'United States'
      _(resume['works'][0]['months_in_position']).must_equal 44
      _(resume['works'][0]['description']).must_include 'Cooperate with designers'
    end

    it 'should return empty lists if none found' do
      list = ['a1121w1w1']
      encoded_list = Jobify::Request::EncodedResumeList.to_encoded(list)

      get "/api/v1/resumes?list=#{encoded_list}"
      _(last_response.status).must_equal 200

      response = JSON.parse(last_response.body)
      resumes = response['resumes']
      _(resumes).must_be_kind_of Array
      _(resumes.count).must_equal 0
    end

    it 'should return error if not list provided' do
      get '/api/v1/resumes'
      _(last_response.status).must_equal 400

      response = JSON.parse(last_response.body)
      _(response['message']).must_include 'list'
    end
  end
end
