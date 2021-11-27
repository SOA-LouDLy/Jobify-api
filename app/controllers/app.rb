# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'

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
    plugin :flash
    plugin :all_verbs # recognizes HTTP verbs beyond GET/POST (e.g., DELETE)
    #plugin :render, engine: 'slim', views: 'app/presentation/views_html'

    use Rack::MethodOverride # for other HTTP verbs (with plugin all_verbs)

    route do |routing|
      routing.assets # load CSS
      routing.public
      # GET /
      routing.root do
        # view 'home'

        # Get Cookie Viewwer's
        session[:watching] ||= []

        resumes = Jobify::Repository::For.klass(Entity::Resume)
          .find_full_identifiers(session[:watching])
          

        session[:watching] = resumes.map(&:identifier)

        if resumes.none?
          flash.now[:notice] = 'Upload a resume to get started.'
        end

        view 'home', locals: { resumes: resumes }
      end
      routing.on 'formats' do 
        routing.is do
          # Form Post to /job/
          routing.post do
            unless routing[:file] &&
                   (tmpfile = routing[:file][:tempfile]) &&
                   (name = routing[:file][:filename])
              flash[:error] = 'No file selected'
              response.status = 400
              # return slim(:formats)
            end
            warn "Uploading file, original name #{name.inspect}"
            resume = Affinda::ResumeMapper.new(App.config.RESUME_TOKEN).resume(tmpfile)
            # Add resume to db
            
            #resume = Repository::For.klass(Entity::Resume)
              #.find_full_resume(identifier)

           

              # Add  to database
              begin
                Repository::For.entity(resume).create(resume)
              rescue StandardError => e
                puts e.backtrace.join("\n")
                flash[:error] = 'Having trouble accessing the database'
              end
            
            routing.redirect "/formats/#{resume.identifier}"
          end
        end

        routing.on String do |identifier|
          # GET /job/skill/location
          routing.delete do
            session[:watching].delete(identifier)

            routing.redirect '/'
          end
          routing.get do
            # resume = Jobify::Repository::For.klass(Entity::Resume)
            # .find_full_resume(identifier)

            begin
              resume = Jobify::Repository::For.klass(Entity::Resume)
                .find_full_resume(identifier)

              if resume.nil?
                flash[:error] = 'resume not found'
                routing.redirect '/'
              end
            rescue StandardError
              flash[:error] = 'Having trouble accessing the database'
              routing.redirect '/'
            end

            view 'formats', locals: { identifier: resume.identifier }
          end
        end
      end

      routing.on 'format1' do
        routing.on String do |identifier|
          begin
            resume = Jobify::Repository::For.klass(Entity::Resume)
              .find_full_resume(identifier)
            analysis = Mapper::Analysis.new(resume).analysis

            if resume.nil?
              flash[:error] = 'resume not found'
              routing.redirect '/'
            end

            if analysis.nil?
              flash[:error] = 'having problem accesing the format'
              routing.redirect '/'
            end
          rescue StandardError
            flash[:error] = 'Having trouble accessing the database'
            routing.redirect '/'
          end
          view 'format1', locals: { resume: resume, analysis: analysis }
        end

        routing.on 'format2' do
          routing.on String do |identifier|
            begin
              resume = Jobify::Repository::For.klass(Entity::Resume)
                .find_full_resume(identifier)
              analysis = Mapper::Analysis.new(resume).analysis

              if resume.nil?
                flash[:error] = 'resume not found'
                routing.redirect '/'
              end

              if analysis.nil?
                flash[:error] = 'having problem accesing the format'
                routing.redirect '/'
              end
            rescue StandardError
              flash[:error] = 'Having trouble accessing the database'
              routing.redirect '/'
            end
            view 'format2', locals: { resume: resume, analysis: analysis }
          end
        end
      end
    end
  end
end
