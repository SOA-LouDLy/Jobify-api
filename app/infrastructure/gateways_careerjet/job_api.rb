# frozen_string_literal: true

require 'careerjet/api_client'

module Jobify
  module CareerJet
    # Library for CareerJet Gem API
    class Api
      def initialize(id)
        @id = id
      end

      def job(skill, location)
        Request.new(@id, skill, location).job
      end
    end

    # Sends request to the Gem API
    class Request
      def initialize(key, skill, location)
        @key = key
        @skill = skill
        @location = location
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
        )
      end
    end
  end
end
