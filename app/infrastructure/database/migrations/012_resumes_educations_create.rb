# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:resumes_educations) do
      primary_key %i[resume_orm_id education_id]
      foreign_key :resume_orm_id, :resumes
      foreign_key :education_id, :educations

      index %i[resume_orm_id education_id]
    end
  end
end
