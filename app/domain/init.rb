# frozen_string_literal: true

folders = %w[resumes analysis]
folders.each do |folder|
  require_relative "#{folder}/init"
end
