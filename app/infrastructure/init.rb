# frozen_string_literal: true

folders = %w[gateways_affinda database messaging]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
