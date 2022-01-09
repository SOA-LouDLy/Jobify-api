# frozen_string_literal: true

require 'roda'
require 'base64'
require 'json'
module Jobify
  # Web App
  class App < Roda
    plugin :halt
    plugin :flash
    plugin :all_verbs # recognizes HTTP verbs beyond GET/POST (e.g., DELETE)
    use Rack::MethodOverride # for other HTTP verbs (with plugin all_verbs)

    # rubocop:disable Metrics/BlockLength
    route do |routing|
      response['Content-Type'] = 'application/json'

      # GET /
      routing.root do
        message = "Jobify API v1 at /api/v1/ in #{App.environment} mode"

        result_response = Representer::HttpResponse.new(
          Response::ApiResult.new(status: :ok, message: message)
        )

        response.status = result_response.http_status_code
        result_response.to_json
      end

      routing.on 'api/v1' do
        routing.on 'resumes' do
          routing.post do
            resume = JSON.parse(routing.body.read)
            request_id = [request.env, request.path, Time.now.to_f].hash

            result = Jobify::Service::AddResume.new.call(
              resume: resume,
              request_id: request_id
            )
            if result.failure?
              failed = Representer::HttpResponse.new(result.failure)
              routing.halt failed.http_status_code, failed.to_json
            end
            http_response = Representer::HttpResponse.new(result.value!)
            response.status = http_response.http_status_code
            # routing.redirect "resumes/#{result.value!.message.identifier}"
            Representer::UploadRequest.new(result.value!.message).to_json
          end

          routing.on Integer do |id|
            routing.get do
              result = Jobify::Service::RetrieveResume.new.call(id)
              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end
              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code
              Representer::Resume.new(result.value!.message).to_json
            end
          end

          routing.on String do |identifier|
            routing.get do
              result = Service::AnalyseResume.new.call(identifier: identifier)

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code

              Representer::ResumeAnalysis.new(
                result.value!.message
              ).to_json
            end
          end

          routing.is do
            # GET /resumes?list={base64_json_array_of_resume_identifiers}
            routing.get do
              list_req = Request::EncodedResumeList.new(routing.params)
              result = Service::ListResumes.new.call(list_request: list_req)

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code
              Representer::ResumesList.new(result.value!.message).to_json
            end
          end
        end
      end
    end
  end
  # rubocop:enable Metrics/BlockLength
end
