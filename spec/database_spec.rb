# frozen_string_literal: false

require_relative 'spec_helper'
require_relative 'helpers/vcr_helper'
require_relative 'helpers/database_helper'

describe 'Integration Tests of Github API and Database' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.def configure_vcr_for_resume
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store project' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should be able to save resume from resume to database' do
      resume = Jobify::Affinda::ResumeMapper
               .new(RESUME_TOKEN, Jobify:Affinda::Api)

      rebuilt_resume = Jobify::Repository::For.entity(resume).create(resume)

      _(rebuilt_resume.certifications.count).must_equal(resume.certifications.count)

      resume.certifications.each do |certificate|
        found_certificate = rebuilt_resume.certifications

        _(found_certificate.name).must_equal certificate.name
      end

      _(rebuilt_resume.birth).must_equal(resume.birth)
      _(rebuilt_resume.education.count).must_equal(resume.education.count)

      resume.education.each do |educate|
        found_educate = rebuilt_resume.education

        _(found_educate.organization).must_equal educate.organization
        _(found_educate.accreditation).must_equal educate.accreditation
        _(found_educate.grade).must_equal educate.grade
        _(found_educate.formatted_location).must_equal educate.formatted_location
        _(found_educate.raw_location).must_equal educate.raw_location
      end
      _(rebuilt_resume.emails.count).must_equal(resume.emails.count)
      resume.emails.each do |mail|
        found_mail = rebuilt_resume.emails

        _(found_mail.email).must_equal mail.email
      end

      _(rebuilt_resume.formatted_location).must_equal(resume.formatted_location)
      _(rebuilt_resume.location).must_equal(resume.location)
      _(rebuilt_resume.country).must_equal(resume.country)
      _(rebuilt_resume.state).must_equal(resume.state)
      _(rebuilt_resume.name).must_equal(resume.name)
      _(rebuilt_resume.objective).must_equal(resume.objective)
      _(rebuilt_resume.phone_numbers.count).must_equal(resume.phone_numbers.count)
      resume.phone_numbers.each do |phone|
        found_phone = rebuilt_resume.phone_numbers

        _(found_phone.phone_numbers).must_equal phone.phone_numbers
      end

      _(rebuilt_resume.sections.count).must_equal(resume.sections.count)
      resume.sections.each do |section|
        found_section = rebuilt_resume.sections

        _(found_section.section_type).must_equal section.section_type
        _(found_section.text).must_equal section.text
      end
      _(rebuilt_resume.skills.count).must_equal(resume.skills.count)
      resume.skills.each do |skill|
        found_skill = rebuilt_resume.skills

        _(found_skill.name).must_equal skill.name
        _(found_skill.experience).must_equal skill.experience
        _(found_skill.name).must_equal skill.name
      end

      _(rebuilt_resume.languages.count).must_equal(resume.languages.count)
      resume.languages.each do |language|
        found_language = rebuilt_resume.languages

        _(found_language.name).must_equal language.name
      end
      _(rebuilt_resume.summary).must_equal(resume.summary)
      _(rebuilt_resume.websites.count).must_equal(resume.websites.count)
      resume.websites.each do |website|
        found_website = rebuilt_resume.websites

        _(found_website.website).must_equal website.website
      end
      _(rebuilt_resume.linkedin).must_equal(resume.linkedin)
      _(rebuilt_resume.total_experience).must_equal(resume.total_experience)
      _(rebuilt_resume.profession).must_equal(resume.profession)
      _(rebuilt_resume.works.count).must_equal(resume.works.count)
      resume.works.each do |work|
        found_work = rebuilt_resume.works

        _(found_work.job_title).must_equal work.job_title
        _(found_work.organization).must_equal work.organization
        _(found_work.formatted_location).must_equal work.formatted_location
        _(found_work.country).must_equal work.country
        _(found_work.raw_location).must_equal work.raw_location
        _(found_work.starting_date).must_equal work.starting_date
        _(found_work.end_date).must_equal work.end_date
        _(found_work.months_in_position).must_equal work.months_in_position
        _(found_work.description).must_equal work.description
      end

      (rebuilt_resume.identifier).must_equal(resume.identifier)
    end
  end
end