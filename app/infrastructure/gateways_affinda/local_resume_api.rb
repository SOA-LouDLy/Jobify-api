# frozen_string_literal: true

require 'yaml'
require 'http'
require 'httmultiparty'

module Jobify
  module Affinda
    # Library for Affinda API
    class LocalApi
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
          c = Curl::Easy.new('https://api.affinda.com/v1/resumes/')
          c.headers['Authorization'] = "Bearer #{@key}"
          c.multipart_form_post = true
          c.http_post(Curl::PostField.file('file', @file))
          JSON.parse(c.body)
        end
      end

      class AffindaClient
        include HTTMultiParty
        base_uri 'https://api.affinda.com/v1'
      end
    end
  end
end
