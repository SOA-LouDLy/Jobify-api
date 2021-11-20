# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:skills) do
      primary_key :id
      # foreign_key :resume_id, :resumes

      String            :name
      Integer           :experience
      String            :type

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
