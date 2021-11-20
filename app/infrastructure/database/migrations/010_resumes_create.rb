# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:resumes) do
      primary_key :id

      String        :identifier, unique: true
      String        :birth
      String        :formatted_location
      String        :location
      String        :country
      String        :state
      String        :name
      String        :objective
      String        :summary
      String        :linkedin
      Integer       :total_experience
      String        :profession

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
