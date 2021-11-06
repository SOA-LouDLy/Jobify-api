# frozen_string_literal: true

module Jobify
  module Repository
    # Repository for Skills
    class Skills
      def self.find_id(id)
        rebuild_entity Database::SkillOrm.first(id: id)
      end

      # def self.find_all
    end
  end
end
