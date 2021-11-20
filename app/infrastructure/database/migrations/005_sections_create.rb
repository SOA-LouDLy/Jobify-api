# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:sections) do
      primary_key :id
      # foreign_key :resume_id, :resumes

      String        :section_type
      String        :text

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
