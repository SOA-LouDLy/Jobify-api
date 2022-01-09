# frozen_string_literal: true

require 'rake/testtask'

task :default do
  puts `rake -T`
end

desc 'Run tests once'
Rake::TestTask.new(:spec) do |t|
  t.pattern = 'spec/tests/{integration,unit}/**/*_spec.rb'
  t.warning = false
end

desc 'Keep rerunning tests upon changes'
task :respec do
  sh "rerun -c 'rake spec' --ignore 'coverage/*'"
end

desc 'Run acceptance tests'
task :spec_accept do
  puts 'NOTE: run `rake run:test` in another process'
  sh 'ruby spec/tests/acceptance/acceptance_spec.rb'
end

desc 'Keep restarting web app upon changes'
task :rerack do
  sh "rerun -c rackup --ignore 'coverage/*'"
end

task :rerack do
  sh "rerun -c rackup --ignore 'coverage/*'"
end

namespace :db do
  task :config do
    require 'sequel'
    require_relative 'config/environment' # load config info
    require_relative 'spec/helpers/database_helper'

    def app() = Jobify::App
  end

  desc 'Run migrations'
  task migrate: :config do
    Sequel.extension :migration
    puts "Migrating #{app.environment} database to latest"
    Sequel::Migrator.run(app.DB, 'app/infrastructure/database/migrations')
  end

  desc 'Wipe records from all tables'
  task wipe: :config do
    if app.environment == :production
      puts 'Do not damage production database!'
      return
    end
    require_relative 'app/infrastructure/database/init'
    require_relative 'spec/helpers/database_helper'
    DatabaseHelper.wipe_database
  end

  desc 'Delete dev or test database file (set correct RACK_ENV)'
  task drop: :config do
    if app.environment == :production
      puts 'Do not damage production database!'
      return
    end

    FileUtils.rm(Jobify::App.config.DB_FILENAME)
    puts "Deleted #{Jobify::App.config.DB_FILENAME}"
  end
end

namespace :queues do
  task :config do
    require 'aws-sdk-sqs'
    require_relative 'config/environment' # load config info
    @api = Jobify::App
    @sqs = Aws::SQS::Client.new(
      access_key_id: @api.config.AWS_ACCESS_KEY_ID,
      secret_access_key: @api.config.AWS_SECRET_ACCESS_KEY,
      region: @api.config.AWS_REGION
    )
    @q_name = @api.config.UPLOAD_QUEUE
    @q_url = @sqs.get_queue_url(queue_name: @q_name).queue_url
    puts "Environment: #{@api.environment}"
  end
  desc 'Create SQS queue for worker'
  task create: :config do
    @sqs.create_queue(queue_name: @q_name)
    puts 'Queue created:'
    puts "  Name: #{@q_name}"
    puts "  Region: #{@api.config.AWS_REGION}"
    puts "  URL: #{@q_url}"
  rescue StandardError => e
    puts "Error creating queue: #{e}"
  end
  desc 'Report status of queue for worker'
  task status: :config do
    puts 'Queue info:'
    puts "  Name: #{@q_name}"
    puts "  Region: #{@api.config.AWS_REGION}"
    puts "  URL: #{@q_url}"
  rescue StandardError => e
    puts "Error finding queue: #{e}"
  end
  desc 'Purge messages in SQS queue for worker'
  task purge: :config do
    @sqs.purge_queue(queue_url: @q_url)
    puts "Queue #{@q_name} purged"
  rescue StandardError => e
    puts "Error purging queue: #{e}"
  end
end
namespace :worker do
  namespace :run do
    desc 'Run the background cloning worker in development mode'
    task dev: :config do
      sh 'RACK_ENV=development bundle exec shoryuken -r ./workers/upload_resume_worker.rb -C ./workers/shoryuken_dev.yml'
    end
    desc 'Run the background cloning worker in testing mode'
    task test: :config do
      sh 'RACK_ENV=test bundle exec shoryuken -r ./workers/upload_resume_worker.rb -C ./workers/shoryuken_test.yml'
    end
    desc 'Run the background cloning worker in production mode'
    task production: :config do
      sh 'RACK_ENV=production bundle exec shoryuken -r ./workers/upload_resume_worker.rb -C ./workers/shoryuken.yml'
    end
  end
end

desc 'Run application console'
task :console do
  sh 'pry -r ./init'
end

namespace :vcr do
  desc 'delete cassette fixtures'
  task :wipe do
    sh 'rm spec/fixtures/cassettes/*.yml' do |ok, _|
      puts(ok ? 'Cassettes deleted' : 'No cassettes found')
    end
  end
end

namespace :quality do
  only_app = 'config/ app/'
  desc 'run all static-analysis quality checks'
  task all: %i[rubocop reek flog]

  desc 'code style linter'
  task :rubocop do
    sh 'rubocop'
  end

  desc 'code smell detector'
  task :reek do
    sh 'reek'
  end

  desc 'complexiy analysis'
  task :flog do
    sh "flog #{only_app}"
  end
end
