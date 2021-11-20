# frozen_string_literal: true

require 'sequel'

module Jobify
  module Database
    # Object Relational Mapper for Resume Entities
    class LanguageOrm < Sequel::Model(:languages)
      many_to_many :resume,
                   class: :'Jobify::Database::ResumeOrm',
                   join_table: :resumes_languages,
                   left_key: :language_id, right_key: :resume_id

      plugin :timestamps, update_on_create: true

      def self.find_or_create(language_info)
        first(name: language_info[:name]) || create(language_info)
      end
    end
  end
end
