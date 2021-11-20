# frozen_string_literal: true

require 'sequel'

module Jobify
  module Database
    # Object Relational Mapper for Resume Entities
    class PhoneOrm < Sequel::Model(:phones)
      many_to_one :resume,
                  class: :'Jobify::Database::ResumeOrm',
                  id: :resume_id

      plugin :timestamps, update_on_create: true

      def self.find_or_create(phone_info)
        first(number: phone_info[:number]) || create(phone_info)
      end
    end
  end
end
