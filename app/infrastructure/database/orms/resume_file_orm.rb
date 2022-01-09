# frozen_string_literal: true

require 'sequel'

module Jobify
  module Database
    # Object Relational Mapper for Resume
    class ResumeFileOrm < Sequel::Model(:resume_files)
      plugin :timestamps, update_on_create: true

      def self.find_or_create(resume_encoded_info)
        create(resume_encoded_info)
      end
    end
  end
end
