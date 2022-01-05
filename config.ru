# frozen_string_literal: true

require_relative './init'
# Rack::Utils.key_space_limit = 262_144
run Jobify::App.freeze.app
