# frozen_string_literal: true


module Jobify
    # Model for Project
    class Job
      def initialize(job)
        @job = job
      end
  
      def date
        @job.date
      end
  
      def url
        @job.url
      end
  
      def title
        @job.title
      end
  
      def description
        @job.description
      end
  
      def company
        @job.company
      end
  
      def locations
        @job.locations
      end
  
    end
end