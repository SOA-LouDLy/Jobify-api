# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:resume_files) do
      primary_key :id

      String :content
      String :result

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
