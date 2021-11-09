# frozen_string_literal: true

require 'sequel'

module Jobify
  module Database
    # Object-Relational Mapper for list of jobs
    class ListJobOrm < Sequel::Model(:list_jobs)
      one_to_many :jobs,
                  class: :'Jobify::Database::JobOrm'

      plugin :timestamps, update_on_create: true
    end
  end
end
