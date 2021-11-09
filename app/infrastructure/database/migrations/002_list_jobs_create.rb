# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:list_jobs) do
      primary_key :id
      foreign_key :job_id, :jobs
      String      :url, null: false

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
