# frozen_string_literal: true

require 'sequel'

module Jobify
  module Database
    # Object Relational Mapper for Job Entities
    class JobOrm < Sequel::Model(:jobs)
      one_to_many :listed_job,
                  class: :'Jobify::Database::ListJobOrm',
                  key: :job_id

      plugin :timestamps, update_on_create: true
    end
  end
end
