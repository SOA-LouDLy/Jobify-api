# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:resumes_skills) do
      primary_key %i[resume_id skill_id]
      foreign_key :resume_id, :resumes
      foreign_key :skill_id, :skills

      index %i[resume_id skill_id]
    end
  end
end
