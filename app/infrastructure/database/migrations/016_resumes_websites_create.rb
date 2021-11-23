# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:resumes_websites) do
      primary_key %i[resume_orm_id website_id]
      foreign_key :resume_orm_id, :resumes
      foreign_key :website_id, :websites

      index %i[resume_orm_id website_id]
    end
  end
end
