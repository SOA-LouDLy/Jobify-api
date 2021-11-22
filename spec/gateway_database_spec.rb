# frozen_string_literal: false

require_relative 'spec_helper'
require_relative 'helpers/vcr_helper'
require_relative 'helpers/database_helper'

describe 'Integration Tests of Affinda API and Database' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_resume
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store resume' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should be able to save resume from resume to database' do
      resume = Jobify::Affinda::ResumeMapper
        .new(RESUME_TOKEN, Jobify::Affinda::LocalApi)
        .resume(FILE)

      rebuilt = Jobify::Repository::For.entity(resume).create(resume)

      # puts resume.identifier
      # puts rebuilt.identifier

      _(rebuilt.identifier).must_equal(resume.identifier)
      _(rebuilt.name).must_equal(resume.name)
      _(rebuilt.birth).must_equal(resume.birth)
      _(rebuilt.formatted_location).must_equal(resume.formatted_location)
      _(rebuilt.location).must_equal(resume.location)
      _(rebuilt.country).must_equal(resume.country)
      _(rebuilt.state).must_equal(resume.state)
      _(rebuilt.objective).must_equal(resume.objective)
      _(rebuilt.summary).must_equal(resume.summary)
      _(rebuilt.linkedin).must_equal(resume.linkedin)
      _(rebuilt.total_experience).must_equal(resume.total_experience)
      _(rebuilt.profession).must_equal(resume.profession)
      _(rebuilt.certifications.count).must_equal(resume.certifications.count)
      _(rebuilt.sections.count).must_equal(resume.sections.count)
      _(rebuilt.skills.count).must_equal(resume.skills.count)
      _(rebuilt.education.count).must_equal(resume.education.count)
      _(rebuilt.languages.count).must_equal(resume.languages.count)
      _(rebuilt.websites.count).must_equal(resume.websites.count)

      @education = rebuilt.education
      @certifications = rebuilt.certifications
      @emails = rebuilt.emails
      @phone_numbers = rebuilt.phone_numbers
      @sections = rebuilt.sections
      @skills = rebuilt.skills
      @languages = rebuilt.languages
      @websites = rebuilt.websites
      @works = rebuilt.works

      resume.education.each.with_index do |degree, index|
        # This is the code that will be run to the tests on education
        _(degree.organization).must_equal @education[index].organization
        _(degree.accreditation).must_equal @education[index].accreditation
        _(degree.grade).must_equal @education[index].grade
        _(degree.formatted_location).must_equal @education[index].formatted_location
        _(degree.raw_location).must_equal @education[index].raw_location
        _(degree.starting_date).must_equal @education[index].starting_date
        _(degree.end_date).must_equal @education[index].end_date
      end

      resume.certifications.each.with_index do |certification, index|
        # This is the code that will be run to the tests on certification
        _(certification.name).must_equal @certifications[index].name
      end

      resume.emails.each.with_index do |email, index|
        _(email.email).must_equal @emails[index].email
        # This is the code that will be run to the tests on emails
      end

      resume.phone_numbers.each.with_index do |phone, index|
        # This is the code that will be run to the tests on phone_numbers
        _(phone.number).must_equal @phone_numbers[index].number
      end

      resume.sections.each.with_index do |section, index|
        # This is the code that will be run to the tests on sections
        _(section.section_type).must_equal @sections[index].section_type
        _(section.text).must_equal @sections[index].text
      end

      resume.skills.each.with_index do |skill, index|
        # This is the code that will be run to the tests on skills
        _(skill.name).must_equal @skills[index].name
        _(skill.experience).must_equal @skills[index].experience
        _(skill.type).must_equal @skills[index].type
      end

      resume.languages.each.with_index do |language, index|
        # This is the code that will be run to the tests on languages
        _(language.name).must_equal @languages[index].name
      end

      resume.websites.each.with_index do |web, index|
        # This is the code that will be run to the tests on websites
        _(web.website).must_equal @websites[index].website
      end

      resume.works.each.with_index do |work, index|
        # This is the code that will be run to the tests on work_experience
        _(work.job_title).must_equal @works[index].job_title
        _(work.organization).must_equal @works[index].organization
        _(work.formatted_location).must_equal @works[index].formatted_location
        _(work.country).must_equal @works[index].country
        _(work.raw_location).must_equal @works[index].raw_location
        _(work.starting_date).must_equal @works[index].starting_date
        _(work.end_date).must_equal @works[index].end_date
        _(work.months_in_position).must_equal @works[index].months_in_position
        _(work.description).must_equal @works[index].description
      end
    end
  end
end
