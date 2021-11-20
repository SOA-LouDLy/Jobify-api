# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:educations) do
      primary_key :id
      # foreign_key :resume_id, :resumes

      String            :organization
      String            :accreditation
      String            :grade
      String            :formatted_location
      String            :raw_location
      String            :starting_date
      String            :end_date

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
