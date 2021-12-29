# frozen_string_literal: true

require_relative 'helpers/spec_helper'
require_relative 'helpers/vcr_helper'

require 'curb'

describe 'Tests Affinda API library' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_resume
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Resume information' do
    it 'HAPPY: should provide correct resume attributes' do
      resume = Jobify::Affinda::ResumeMapper.new(RESUME_TOKEN)
        .resume(FILE)

      _(resume.name).must_equal DATA['name']['raw']
      _(resume.birth).must_equal DATA['dateOfBirth']
      # _(resume.emails).must_equal DATA['emails']
      _(resume.formatted_location).must_equal DATA['location']['formatted']
      _(resume.location).must_equal DATA['location']['rawInput']
      _(resume.country).must_equal DATA['country']
      _(resume.state).must_equal DATA['state']
      # _(resume.phone_numbers).must_equal DATA['phoneNumbers']
      # _(resume.languages).must_equal DATA['languages']
      _(resume.summary).must_equal DATA['summary']
      _(resume.linkedin).must_equal DATA['linkedin']
      _(resume.total_experience).must_equal DATA['totalYearsExperience']
      _(resume.profession).must_equal DATA['profession']
      _(resume.websites).must_equal DATA['websites']
      _(resume.objective).must_equal DATA['objective']
    end
  end

  describe 'Education information' do
    before do
      @resume = Jobify::Affinda::ResumeMapper.new(RESUME_TOKEN)
        .resume(FILE)
      @educations_data = DATA['education'].map do |education|
        Jobify::Entity::Education.new(
          id: nil,
          organization: education['organization'],
          accreditation: education['accreditation']['inputStr'],
          grade: education['grade'],
          formatted_location: education['location']['formatted'],
          raw_location: education['location']['rawInput'],
          starting_date: education['dates']['startDate'],
          end_date: education['dates']['completionDate']
        )
      end
      @education = @resume.education
    end

    it 'HAPPY: should recognize education' do
      _(@education[0]).must_be_kind_of Jobify::Entity::Education
    end

    it 'HAPPY: should verify education information' do
      @educations_data.each.with_index do |education, index|
        _(@education[index].organization).must_equal education.organization
        _(@education[index].accreditation).must_equal education.accreditation
        _(@education[index].grade).must_equal education.grade
        _(@education[index].formatted_location).must_equal education.formatted_location
        _(@education[index].raw_location).must_equal education.raw_location
        _(@education[index].starting_date).must_equal education.starting_date
        _(@education[index].end_date).must_equal education.end_date
      end
    end
  end

  describe 'Section information' do
    before do
      @resume = Jobify::Affinda::ResumeMapper.new(RESUME_TOKEN)
        .resume(FILE)
      @sections_data = DATA['sections'].map do |section|
        Jobify::Entity::Section.new(
          id: nil,
          section_type: section['sectionType'],
          text: section['text']
        )
      end
      @sections = @resume.sections
    end

    it 'HAPPY: should recognize section' do
      _(@sections[0]).must_be_kind_of Jobify::Entity::Section
    end

    it 'HAPPY: should verify section information' do
      @sections_data.each.with_index do |section, index|
        _(@sections[index].section_type).must_equal section.section_type
        _(@sections[index].text).must_equal section.text
      end
    end
  end

  describe 'Skill information' do
    before do
      @resume = Jobify::Affinda::ResumeMapper.new(RESUME_TOKEN)
        .resume(FILE)
      @skills_data = DATA['skills'].map do |skill|
        Jobify::Entity::Skill.new(
          id: nil,
          name: skill['name'],
          experience: skill['numberOfMonths'],
          type: skill['type']
        )
      end
      @skills = @resume.skills
    end

    it 'HAPPY: should recognize skill' do
      _(@skills[0]).must_be_kind_of Jobify::Entity::Skill
    end

    it 'HAPPY: should verify skill information' do
      @skills_data.each.with_index do |skill, index|
        _(@skills[index].name).must_equal skill.name
        _(@skills[index].experience).must_equal skill.experience
        _(@skills[index].type).must_equal skill.type
      end
    end
  end

  describe 'Work information' do
    before do
      @resume = Jobify::Affinda::ResumeMapper.new(RESUME_TOKEN)
        .resume(FILE)
      @work_data = DATA['workExperience'].map do |work|
        Jobify::Entity::Work.new(
          id: nil,
          job_title: work['jobTitle'],
          organization: work['organization'],
          formatted_location: work['location']['formatted'],
          country: work['location']['country'],
          raw_location: work['location']['rawInput'],
          starting_date: work['dates']['startDate'],
          end_date: work['dates']['endDate'],
          months_in_position: work['dates']['monthsInPosition'],
          description: work['jobDescription']
        )
      end
      @work = @resume.works
    end

    it 'HAPPY: should recognize work' do
      _(@work[0]).must_be_kind_of Jobify::Entity::Work
    end

    it 'HAPPY: should verify work information' do
      @work_data.each.with_index do |work, index|
        _(@work[index].job_title).must_equal work.job_title
        _(@work[index].organization).must_equal work.organization
        _(@work[index].formatted_location).must_equal work.formatted_location
        _(@work[index].country).must_equal work.country
        _(@work[index].raw_location).must_equal work.raw_location
        _(@work[index].starting_date).must_equal work.starting_date
        _(@work[index].end_date).must_equal work.end_date
        _(@work[index].months_in_position).must_equal work.months_in_position
        _(@work[index].description).must_equal work.description
      end
    end
  end

  describe 'Certification information' do
    before do
      @resume = Jobify::Affinda::ResumeMapper.new(RESUME_TOKEN)
        .resume(FILE)
      @certifications_data = DATA['certifications'].map do |certification|
        Jobify::Entity::Certification.new(
          id: nil,
          name: certification
        )
      end
      @certifications = @resume.certifications
    end

    it 'HAPPY: should recognize certification' do
      _(@certifications[0]).must_be_kind_of Jobify::Entity::Certification
    end

    it 'HAPPY: should verify certification information' do
      @certifications_data.each.with_index do |certification, index|
        _(@certifications[index].name).must_equal certification.name
      end
    end
  end

  describe 'Website information' do
    before do
      @resume = Jobify::Affinda::ResumeMapper.new(RESUME_TOKEN)
        .resume(FILE)
      @websites_data = DATA['websites'].map do |website|
        Jobify::Entity::Website.new(
          id: nil,
          website: website
        )
      end
      @websites = @resume.websites
    end

    it 'HAPPY: should recognize website' do
      _(@websites[0]).must_be_kind_of Jobify::Entity::Website
    end

    it 'HAPPY: should verify website information' do
      @websites_data.each.with_index do |website, index|
        _(@websites[index].website).must_equal website.website
      end
    end
  end

  describe 'Phone information' do
    before do
      @resume = Jobify::Affinda::ResumeMapper.new(RESUME_TOKEN)
        .resume(FILE)
      @phones_data = DATA['phoneNumbers'].map do |number|
        Jobify::Entity::Phone.new(
          id: nil,
          number: number
        )
      end
      @phones = @resume.phone_numbers
    end

    it 'HAPPY: should recognize phone number' do
      _(@phones[0]).must_be_kind_of Jobify::Entity::Phone
    end

    it 'HAPPY: should verify phone information' do
      @phones_data.each.with_index do |phone, index|
        _(@phones[index].number).must_equal phone.number
      end
    end
  end
end
