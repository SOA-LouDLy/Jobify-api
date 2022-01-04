# frozen_string_literal: true

require 'yaml'
require 'http'
require 'uri'
require 'net/http'

module Jobify
  module Affinda
    # Library for Affinda API
    class Api
      API_RESUME_ROOT = 'https://api.affinda.com/v1/resumes/'

      def initialize(id)
        @id = id
      end

      def resume(file)
        JSON.parse(Request.new(@id, file).resume)
      end

      # Sends POST request to Affinda API and GETs the response
      class Request
        def initialize(key, file)
          @key = key
          @file = file
        end

        def resume
          uri = URI.parse(API_RESUME_ROOT)
          request = Net::HTTP::Post.new(uri)
          request['Authorization'] = "Bearer #{@key}"
          form_data = [['file', File.open(@file)]]
          request.set_form form_data, 'multipart/form-data'
          http_response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
            http.request(request)
          end
          http_response.body
          # return http_response.body unless http_response.code != 200
        end
      end
    end
  end
end
