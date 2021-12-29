# frozen_string_literal: true

require 'yaml'
require 'http'

module Jobify
  module Affinda
    # Library for Affinda API
    class Api
      API_RESUME_ROOT = 'https://api.affinda.com/v1/resumes/'

      def initialize(id)
        @id = id
      end

      def resume(file)
        Request.new(@id, file).resume.parse
      end

      # Sends POST request to Affinda API and GETs the response
      class Request
        def initialize(key, file)
          @key = key
          @file = file
        end

        def resume
          http_response = HTTP.headers(
            'Authorization' => "Bearer #{@key}"
          ).post(API_RESUME_ROOT, form: {
                   file: HTTP::FormData::File.new(@file)
                 })
          # puts http_response
          Response.new(http_response).tap do |response|
            raise(response.error) unless response.successful?
          end
        end
      end

      # Decorates HTTP responses from Affinda with success/error
      class Response < SimpleDelegator
        Unauthorized = Class.new(StandardError)
        NotFound = Class.new(StandardError)

        HTTP_ERROR = {
          401 => Unauthorized,
          404 => NotFound
        }.freeze

        def successful?
          !HTTP_ERROR.keys.include?(code)
        end

        def error
          HTTP_ERROR[code]
        end
      end
    end
  end
end
