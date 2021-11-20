# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:phones) do
      primary_key :id
      foreign_key :resume_orm_id, :resumes

      String :number

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
