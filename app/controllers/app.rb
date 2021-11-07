# frozen_string_literal: true

require 'roda'
require 'slim'

module Jobify
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :halt

    route do |routing| # rubocop:disable Metrics/BlockLength
      routing.assets # load CSS

      # GET /
      routing.root do
        view 'home'
      end
      routing.on 'jobs' do
        routing.is do
          # Form Post to /job/
          routing.post do
            skill_entered = routing.params['skill'].downcase
            location_entered = routing.params['location'].downcase
            skill = skill_entered.split.join('+')
            location = location_entered.split.join('+')

            routing.halt 400 if skill.empty? || location.empty?

            # Get job from CareerJet
            jobs = CareerJet::JobMapper
                   .new(App.config.JOB_TOKEN)
                   .get_jobs(skill, location)

            # Add jobs to database
            Repository::For.entity(jobs).create(jobs)

            # Redirect users to the jobs Page
            routing.redirect "jobs/#{skill}/#{location}"
          end
        end

        routing.on String, String do |skill, location|
          # GET /job/skill/location
          routing.get do
            # careerjet_jobs = CareerJet::JobMapper
            #                  .new(JOB_TOKEN)
            #                  .get_jobs(skill, location)
            careerjet_jobs = Repository::For.klass(Entity::Job)
                                            .find_url(skill, location)
            view 'job', locals: { jobs: careerjet_jobs } unless careerjet_jobs.nil?
          end
        end
      end
    end
  end
end
