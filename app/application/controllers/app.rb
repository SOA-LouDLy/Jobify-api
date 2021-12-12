# frozen_string_literal: true

require 'roda'

module Jobify
  # Web App
  class App < Roda
    plugin :public, root: 'app/presentation/public'
    plugin :halt
    plugin :flash
    plugin :all_verbs # recognizes HTTP verbs beyond GET/POST (e.g., DELETE)
    # plugin :render, engine: 'slim', views: 'app/presentation/views_html'

    use Rack::MethodOverride # for other HTTP verbs (with plugin all_verbs)

    route do |routing|
      response['Content-Type'] = 'application/json'
      routing.public
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
        routing.on 'formats' do
          routing.on String do |identifier|
            # GET /formats/{identifier}
            routing.get do
              resume_made = Service::GetResume.new.call(identifier)
              if resume_made.failure?
                failed = Representer::HttpResponse.new(resume_made.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(resume_made.value!)
              response.status = http_response.http_status_code

              # Representer::NameOfTheClass.new(
              #  result.value!.message
              # ).to_json
            end
          end
        end
      end

      routing.on 'format1' do
        routing.on String do |identifier|
          resume_made = Service::GetResume.new.call(identifier)
          if resume_made.failure?
            failed = Representer::HttpResponse.new(resume_made.failure)
            routing.halt failed.http_status_code, failed.to_json
          end

          resume = resume_made.value!
          analysis = Mapper::Analysis.new(resume).analysis

          if analysis.nil?
            failed = Representer::HttpResponse.new(analysis.nil)
            routing.halt failed.http_status_code, failed.to_json
          end

          http_response = Representer::ResumeAnalysis.new(resume, analysis)
          response.status = http_response.http_status_code
        end

        routing.on 'format2' do
          routing.on String do |identifier|
            resume_made = Service::GetResume.new.call(identifier)
            if resume_made.failure?
              failed = Representer::HttpResponse.new(resume_made.failure)
              routing.halt failed.http_status_code, failed.to_json
            end
            resume = resume_made.value!
            analysis = Mapper::Analysis.new(resume).analysis

            if analysis.nil?
              failed = Representer::HttpResponse.new(analysis.nil)
              routing.halt failed.http_status_code, failed.to_json
            end

            http_response = Representer::ResumeAnalysis.new(resume, analysis)
            response.status = http_response.http_status_code
          end
        end
      end
    end
  end
end
