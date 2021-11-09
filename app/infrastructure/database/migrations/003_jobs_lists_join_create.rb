# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:jobs_list_jobs) do
      primary_key %i[job_id list_job_id]
      foreign_key :job_id, :jobs
      foreign_key :list_job_id, :list_jobs

      index %i[job_id list_job_id]
    end
  end
end
