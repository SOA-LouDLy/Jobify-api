# frozen_string_literal: true

module Jobify
  module Service
    # Transaction to retrieve a resume from database
    class GetResume
      include Dry::Transaction
      step :retrieve_resume

      private

      def retrieve_resume(identifier)
        resume = Jobify::Repository::For.klass(Entity::Resume)
          .find_full_resume(identifier)
        Success(resume)
      rescue StandardError => e
        puts e.backtrace.join("\n")
        Failure('Having trouble accessing the database')
      end
    end
  end
end
