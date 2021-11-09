# frozen_string_literal: true

require 'sequel'

module Jobify
  module Database
    # Object-Relational Mapper for URL
    class UrlOrm < Sequel::Model(:list_jobs)
      many_to_one :job,
                  class: :'CodePraise::Database::JobOrm'
                
      plugin :timestamps, update_on_create: true
    end
  end
end