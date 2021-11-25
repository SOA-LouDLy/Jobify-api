# frozen_string_literal: true

require 'yaml'
require 'http'
require 'httmultiparty'

module Jobify
  module Affinda
    # Library for Affinda API
    class Api
      # API_RESUME_ROOT = 'https://api.affinda.com/v1/resumes/'

      def initialize(id)
        @id = id
      end

      def resume(file)
        Request.new(@id, file).resume
      end

      # Sends POST request to Affinda API and GETs the response
      class Request
        def initialize(key, file)
          @key = key
          @file = file
        end

        def resume
          headers = {
            Authorization: "Bearer #{@key}"
          }
          params = {
            file: @file
          }
          response = AffindaClient.post('/resumes', query: params, headers: headers)
          puts response
          JSON.parse(response.body)
        end
      end

      def error
        HTTP_ERROR[code]
      end

      # Allow HTTP posts
      class AffindaClient
        include HTTMultiParty
        base_uri 'https://api.affinda.com/v1'
      end
    end
  end
end
