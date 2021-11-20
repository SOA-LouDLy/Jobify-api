# frozen_string_literal: true

require 'sequel'

module Jobify
  module Database
    # Object Relational Mapper for Resume Entities
    class WebsiteOrm < Sequel::Model(:websites)
      many_to_many :resumes,
                   class: :'Jobify::Database::ResumeOrm',
                   join_table: :resumes_websites,
                   left_key: :website_id, right_key: :resume_id

      plugin :timestamps, update_on_create: true

      def self.find_or_create(website_info)
        first(website: website_info[:website]) || create(website_info)
      end
    end
  end
end
