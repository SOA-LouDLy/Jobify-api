# frozen_string_literal: true

# Helper to clean database during test runs
module DatabaseHelper
  def self.wipe_database
    # Ignore foreign key constraints when wiping tables
    Jobify::App.DB.run('PRAGMA foreign_keys = OFF')
    Jobify::Database::ResumeOrm.map(&:destroy)
    Jobify::Database::LanguageOrm.map(&:destroy)
    Jobify::Database::PhoneOrm.map(&:destroy)
    Jobify::Database::SectionOrm.map(&:destroy)
    Jobify::Database::SkillOrm.map(&:destroy)
    Jobify::Database::WebsiteOrm.map(&:destroy)
    Jobify::Database::WorkOrm.map(&:destroy)
    Jobify::Database::CertificationOrm.map(&:destroy)
    Jobify::Database::EducationOrm.map(&:destroy)
    Jobify::Database::EmailOrm.map(&:destroy)
    Jobify::App.DB.run('PRAGMA foreign_keys = ON')
  end
end
