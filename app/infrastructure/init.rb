# frozen_string_literal: true

folders = %w[gateways_affinda database]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
