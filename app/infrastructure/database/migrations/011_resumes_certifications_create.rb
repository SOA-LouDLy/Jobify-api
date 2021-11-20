# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:resumes_certifications) do
      primary_key %i[resume_id certification_id]
      foreign_key :resume_id, :resumes
      foreign_key :certification_id, :certifications

      index %i[resume_id certification_id]
    end
  end
end
