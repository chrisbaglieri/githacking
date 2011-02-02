# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'webmock/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
end

def stub_anonymous_user_request username='someuser'
  stub_request(:get, "https://github.com/api/v2/yaml/user/show/#{username}?").
    to_return(status: 200, body: <<USER, headers: {})
user:
  gravatar_id: b8dbb1987e8e5318584865f880036796
  company: GitHub
  name: Firstname Lastname
  created_at: 2007/10/19 22:24:19 -0700
  location: San Francisco CA
  public_repo_count: 98
  public_gist_count: 270
  blog: http://google.com/
  following_count: 196
  id: 2
  type: User
  permission: null
  followers_count: 1692
  login: #{username}
  email: address@email.com
USER
  
end

def stub_anonymous_repo_request repo=(Factory.build :repository)
  stub_request(:get, "https://github.com/api/v2/yaml/repos/show/#{repo.user}/#{repo.project_name}?").
    to_return(:status => 200, :body => <<BODY, :headers => {})
repository:
  url: https://github.com/#{repo.user}/#{repo.project_name}
  has_issues: true
  homepage: http://#{repo.project_name}.rubyforge.org/
  watchers: 106
  source: otheruser/#{repo.project_name}
  parent: otheruser/#{repo.project_name}
  has_downloads: true
  created_at: 2008/04/18 16:14:24 -0700
  forks: 11
  fork: true
  has_wiki: true
  private: false
  pushed_at: 2010/05/05 15:28:38 -0700
  name: #{repo.project_name}
  description: This is the description of #{repo.project_name}.
  owner: #{repo.user}
  open_issues: 0
BODY
end

def stub_anonymous_repo_languages_request repo=(Factory.build :repository)
  stub_request(:get, "https://github.com/api/v2/yaml/repos/show/#{repo.user}/#{repo.project_name}/languages?").
    to_return(:status => 200, :body => <<BODY, :headers => {})
languages:
  Ruby: 223245
BODY
end

def stub_authenticated_user_request username='theuser'
  body = <<USER
--- 
user: 
  gravatar_id: b8dbb1987e8e5318584865f880036796
  company: GitHub
  name: Firstname Lastname
  created_at: 2007/10/19 22:24:19 -0700
  location: San Francisco, CA
  public_repo_count: 98
  public_gist_count: 270
  blog: http://google.com/
  following_count: 196
  id: 2
  type: User
  permission: 
  followers_count: 1692
  login: #{username}
  email: address@email.com
  total_private_repo_count: 1
  collaborators: 3
  disk_usage: 50384
  owned_private_repo_count: 1
  private_gist_count: 0
  plan: 
    name: mega
    collaborators: 60
    space: 20971520
    private_repos: 125
 
USER
  stub_request(:get, /https:\/\/github.com\/api\/v2\/yaml\/user\/show\/(.+)\??/).
    to_return(status: 200, body: body, headers: {})

  stub_request(:get, /https:\/\/github.com\/api\/v2\/yaml\/user\/show\??/).
    to_return(status: 200, body: body, headers: {})

  

end

def stub_all_github_requests_for repo
  stub_anonymous_user_request repo.user
  stub_anonymous_repo_request repo
  stub_anonymous_repo_languages_request repo
end
