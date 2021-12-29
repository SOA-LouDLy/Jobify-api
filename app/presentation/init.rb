# frozen_string_literal: true

infos = %w[responses representers]
infos.each do |info|
  require_relative "#{info}/init.rb"
end
