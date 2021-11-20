# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:works) do
      primary_key :id
      foreign_key :resume_orm_id, :resumes

      String            :job_title
      String            :organization
      String            :formatted_location
      String            :country
      String            :raw_location
      String            :starting_date
      String            :end_date
      Integer           :months_in_position
      String            :description

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
