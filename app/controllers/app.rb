# frozen_string_literal: true

require 'roda'
require 'slim'

module Jobify
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :public, root: 'app/views/public'
    plugin :assets, path: 'app/views/assets',
                    css: { format1: 'format1.css',
                           format2: 'format2.css',
                           layout: 'style.css',
                           formats: 'formats.css' }, js: 'table_row_click.js'
    plugin :halt

    route do |routing|
      routing.assets # load CSS
      routing.public
      # GET /
      routing.root do
        # view 'home'
        resumes = Jobify::Repository::For.klass(Entity::Resume).all
        view 'home', locals: { resumes: resumes }
      end
      routing.on 'formats' do
        routing.is do
          # Form Post to /job/
          routing.post do
            unless routing[:file] &&
                   (tmpfile = routing[:file][:tempfile]) &&
                   (name = routing[:file][:filename])
              @error = 'No file selected'
              # return slim(:formats)
            end
            warn "Uploading file, original name #{name.inspect}"
            resume = Affinda::ResumeMapper.new(App.config.RESUME_TOKEN).resume(tmpfile)
            # Add resume to db
            Repository::For.entity(resume).create(resume)
            routing.redirect "/formats/#{resume.identifier}"
          end
        end

        routing.on String do |identifier|
          # GET /job/skill/location
          routing.get do
            resume = Jobify::Repository::For.klass(Entity::Resume)
              .find_full_resume(identifier)

            view 'formats', locals: { identifier: resume.identifier }

          end
        end
      end
      routing.on 'format1' do
        routing.on String do |identifier|
          resume = Jobify::Repository::For.klass(Entity::Resume)
            .find_full_resume(identifier)
          analysis = Mapper::Analysis.new(resume).analysis
          view 'format1', locals: { resume: resume, analysis: analysis }
        end
      end

      routing.on 'format2' do
        routing.on String do |identifier|
          resume = Jobify::Repository::For.klass(Entity::Resume)
            .find_full_resume(identifier)
          analysis = Mapper::Analysis.new(resume).analysis
          view 'format2', locals: { resume: resume, analysis: analysis }
        end
      end
    end
  end
end
