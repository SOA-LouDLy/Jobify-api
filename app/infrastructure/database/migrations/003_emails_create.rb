# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:emails) do
      primary_key :id
      foreign_key :resume_orm_id, :resumes

      String :email

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
