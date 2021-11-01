# frozen_string_literal: true

require_relative 'job'
require 'careerjet/api_client'

module Jobify
  # Library for CareerJet Gem API
  class CarrerjetApi
    def initialize(id)
      @id = id
    end

    def job(skill, location)
      jobs_data = Request.new(@id, skill, location).job
      jobs_data.jobs.map { |job| Job.new(job) }
    end
  end

  # Sends request to the Gem API
  class Request
    # def initialize(key, skill, location, contracttype = 'none', contractperiod = 'none')
    def initialize(key, skill, location)
      @key = key
      @skill = skill
      @location = location
      #   @contracttype = contracttype
      #   @contractperiod = contractperiod
    end

    def job
      cj_api_client = Careerjet::APIClient.new(locale: :en_GB)
      cj_api_client.search(
        keywords: @skill,
        location: @location,
        affid: @key,
        user_ip: '11.22.33.44',
        user_agent: 'Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Firefox/31.0',
        url: 'http://www.example.com/jobsearch?q=ruby&l=london',
        sort: 'date'
        # contracttype: 'p',
        # contractperiod: 'p'
      )
    end
  end
end
