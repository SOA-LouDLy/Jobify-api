# frozen_string_literal: true

require 'careerjet/api_client'
require 'yaml'

cj_api_client = Careerjet::APIClient.new(locale: :en_GB)
job_results = cj_api_client.search(
  keywords: 'ruby',
  location: 'london',
  affid: '5d1c7d2cf53d142f9e36c9ad2148a51c',
  user_ip: '11.22.33.44',
  user_agent: 'Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Firefox/31.0',
  url: 'http://www.example.com/jobsearch?q=ruby&l=london',
  sort: 'date'
)

File.write('spec/fixtures/carrerjet_results.yml', job_results.to_yaml)
