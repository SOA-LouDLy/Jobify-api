# frozen_string_literal: false

%w[entities mappers repositories]
  .each do |folder|
  Dir.glob("#{__dir__}/#{folder}/**/*.rb").each do |ruby_file|
    require_relative ruby_file
  end
end
