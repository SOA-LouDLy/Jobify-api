# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'

module Jobify
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/presentation/views_html'
    plugin :public, root: 'app/presentation/public'
    plugin :assets, path: 'app/presentation/assets',
                    css: { format1: 'format1.css',
                           format2: 'format2.css',
                           layout: 'style.css',
                           formats: 'formats.css' }, js: 'table_row_click.js'
    plugin :halt
    plugin :flash
    plugin :all_verbs # recognizes HTTP verbs beyond GET/POST (e.g., DELETE)
    # plugin :render, engine: 'slim', views: 'app/presentation/views_html'

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

        viewable_resume = Views::ResumesList.new(resumes)
        view 'home', locals: { resumes: viewable_resume }
      end
      routing.on 'formats' do
        routing.is do
          # Form Post to /formats/
          routing.post do
            unless routing[:file] &&
                   (tmpfile = routing[:file][:tempfile]) &&
                   (name = routing[:file][:filename])
              response.status = 400
              # return slim(:formats)
            end
            warn "Uploading file, original name #{name.inspect}"
            resume = Affinda::ResumeMapper.new(App.config.RESUME_TOKEN).resume(tmpfile)

            begin
              Repository::For.entity(resume).create(resume)
            rescue StandardError => e
              puts e.backtrace.join("\n")
            end
            # Add new resume to watched set in cookies
            session[:watching].insert(0, resume.identifier).uniq!
            routing.redirect "/formats/#{resume.identifier}"
          end
        end

        routing.on String do |identifier|
          # GET /formats/{identifier}
          routing.get do
            begin
              resume = Jobify::Repository::For.klass(Entity::Resume)
                .find_full_resume(identifier)

              routing.redirect '/' if resume.nil?
            rescue StandardError
              routing.redirect '/'
            end

            view 'formats', locals: { identifier: resume.identifier }
          end
        end
      end

      routing.on 'format1' do
        routing.on String do |identifier|
          routing.delete do
            session[:watching].delete(identifier)

            routing.redirect '/'
          end
          begin
            resume = Jobify::Repository::For.klass(Entity::Resume)
              .find_full_resume(identifier)
            analysis = Mapper::Analysis.new(resume).analysis

            routing.redirect '/' if resume.nil?

            routing.redirect '/' if analysis.nil?
          rescue StandardError
            routing.redirect '/'
          end
          resume_analysis = Views::ResumeAnalysis.new(resume, analysis)
          view 'format1', locals: { analysis: resume_analysis }
        end

        routing.on 'format2' do
          routing.on String do |identifier|
            begin
              resume = Jobify::Repository::For.klass(Entity::Resume)
                .find_full_resume(identifier)
              analysis = Mapper::Analysis.new(resume).analysis

              routing.redirect '/' if resume.nil?

              routing.redirect '/' if analysis.nil?
            rescue StandardError
              flash[:error] = 'Having trouble accessing the database'
              routing.redirect '/'
            end
            resume_analysis = Views::ResumeAnalysis.new(resume, analysis)
            view 'format2', locals: { analysis: resume_analysis }
          end
        end
      end
    end
  end
end
