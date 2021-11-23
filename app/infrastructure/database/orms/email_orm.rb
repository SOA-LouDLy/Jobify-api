# frozen_string_literal: true

require 'sequel'

module Jobify
  module Database
    # Object Relational Mapper for Resume Entities
    class EmailOrm < Sequel::Model(:emails)
      many_to_one :resume,
                  class: :'Jobify::Database::ResumeOrm'
      #   id: :resume_id

      plugin :timestamps, update_on_create: true

      def self.find_or_create(email_info)
        first(email: email_info[:email]) || create(email_info)
      end
    end
  end
end
