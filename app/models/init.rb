# frozen_string_literal: false

%w[entities gateways_affinda gateways_careerjet mappers]
  .each do |folder|
  Dir.glob("#{__dir__}/#{folder}/**/*.rb").each do |ruby_file|
    require_relative ruby_file
  end
end
