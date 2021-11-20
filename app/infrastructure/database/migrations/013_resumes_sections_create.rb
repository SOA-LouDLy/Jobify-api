# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:resumes_sections) do
      primary_key %i[resume_id section_id]
      foreign_key :resume_id, :resumes
      foreign_key :section_id, :sections

      index %i[resume_id section_id]
    end
  end
end
