# frozen_string_literal: true

# Helper to clean database during test runs
module DatabaseHelper
  def self.wipe_database
    # Ignore foreign key constraints when wiping tables
    Jobify::App.DB.run('PRAGMA foreign_keys = OFF')
    Jobify::Database::LinkOrm.map(&:destroy)
    Jobify::Database::JobOrm.map(&:destroy)
    Jobify::App.DB.run('PRAGMA foreign_keys = ON')
  end
end
