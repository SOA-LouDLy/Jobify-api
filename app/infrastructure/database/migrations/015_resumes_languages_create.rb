# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:resumes_languages) do
      primary_key %i[resume_id language_id]
      foreign_key :resume_id, :resumes
      foreign_key :language_id, :languages

      index %i[resume_id language_id]
    end
  end
end
