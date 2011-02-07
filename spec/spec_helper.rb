require 'simplecov'
SimpleCov.start 'rails'

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

def stub_anonymous_user_request options={}
  options.reverse_merge!(company: 'GitHacking',
                         name: 'Firstname Lastname',
                         created_at: '2007/10/19 22:24:19 -0700',
                         location: 'San Francisco CA',
                         public_repo_count: 98,
                         public_gist_count: 210,
                         blog: 'http://blog.com',
                         following_count: 129,
                         id: 3,
                         type: 'User',
                         permission: 'null',
                         followers_count: 1692,
                         login: 'someuser',
                         email: 'abc@email.com')
  stub_request(:get, "https://github.com/api/v2/yaml/user/show/#{options[:login]}?").
    to_return(status: 200, body: <<USER, headers: {})
user:
  company: #{options[:company]}
  name: #{options[:name]}
  created_at: #{options[:created_at]}
  location: #{options[:location]}
  public_repo_count: #{options[:public_repo_count]}
  public_gist_count: #{options[:public_gist_count]}
  blog: #{options[:blog]}
  gravatar_id: includedeventhoughwedontuseit
  following_count: #{options[:following_count]}
  id: #{options[:id]}
  type: #{options[:type]}
  permission: #{options[:permission]}
  followers_count: #{options[:followers_count]}
  login: #{options[:login]}
  email: #{options[:email]}
USER
  
end

def stub_anonymous_repo_request_from_factory repo=(Factory.build :repository)
  stub_anonymous_repo_request(repo.attributes.symbolize_keys)
end

def stub_anonymous_repo_request options={}
  # Set defaults
  options.reverse_merge!(url: "https://github.com/someowner/some_project",
                         owner: 'someowner',
                         name: 'some_project',
                         has_issues: true,
                         watchers: 25,
                         has_downloads: true,
                         created_at: '2008/04/18 16:14:24 -0700',
                         forks: 11,
                         fork: true,
                         source: '', # 'somesource/project',
                         parent: '', # 'parent/project',
                         has_wiki: true,
                         private: false,
                         homepage: 'http://homepage.com',
                         pushed_at: '2010/05/05 15:28:38 -0700',
                         description: "This is the description of #{options[:name] || 'some_project'}.",
                         open_issues: 3)
                         
  stub_request(:get, "https://github.com/api/v2/yaml/repos/show/#{options[:owner]}/#{options[:name]}?").
    to_return(:status => 200, :body => <<BODY, :headers => {})
repository:
  url: #{options[:url]}
  has_issues: #{options[:has_issues]}
  homepage: #{options[:homepage]}
  watchers: #{options[:watchers]}
  source: #{options[:source]}
  parent: #{options[:parent]}
  has_downloads: #{options[:has_downloads]}
  created_at: #{options[:created_at]}
  forks: #{options[:forks]}
  fork: #{options[:fork]}
  has_wiki: #{options[:has_wiki]}
  private: #{options[:private]}
  pushed_at: #{options[:pushed_at]}
  name: #{options[:name]}
  description: #{options[:description]}
  owner: #{options[:owner]}
  open_issues: #{options[:open_issues]}
BODY
end

def stub_anonymous_repo_languages_request options={}
  options.reverse_merge!(owner: 'notspecifiedowner',
                         name: 'notspecifiedname',
                         languages: {'Ruby' => 12345, 'JavaScript' => 5431})
  stub_request(:get, "https://github.com/api/v2/yaml/repos/show/#{options.delete :owner}/#{options.delete :name}/languages?").
    to_return(:status => 200, :body => options.to_yaml, :headers => {})
end

def stub_metadata_request owner, project_name
  stub_request(:get, "https://github.com/#{owner}/#{project_name}/raw/master/githacking.yaml"). to_return(:status => 200, body: <<BODY, :headers => {})
---
long_description: >
    hello world this is a test for githacking at philly startup weekend!

categories:
    - clojure
    - rabbitmq

needs:
    roles:
        - developers
        - evangelists
        - testers
        - ui
    skills:
        - awesome people

mentions:
    - http://aaronfeng.com
    - http://twitter.com/aaronfeng
BODY

end

def stub_authenticated_user_request options={}
  options.reverse_merge!(company: 'GitHacking',
                         name: 'Firstname Lastname',
                         created_at: '2007/10/19 22:24:19 -0700',
                         location: 'San Francisco CA',
                         public_repo_count: 98,
                         public_gist_count: 210,
                         blog: 'http://blog.com',
                         following_count: 129,
                         id: 3,
                         type: 'User',
                         permission: 'null',
                         followers_count: 1692,
                         login: 'someuser',
                         email: username + '@email.com',
                         total_private_repo_count: 1,
                         collaborators: 3,
                         disk_usage: 50384,
                         owned_private_repo_count: 1,
                         private_gist_count: 0,
                         plan_name: mega,
                         plan_collaborators: 60,
                         plan_space: 20971520,
                         plan_private_repos: 125)
                         public
  stub_request(:get, "https://github.com/api/v2/yaml/user/show/#{username}?").
    to_return(status: 200, body: <<BODY, headers: {})
--- 
user: 
  company: #{options[:company]}
  name: #{options[:name]}
  created_at: #{options[:created_at]} 
  location: #{options[:location]}
  public_repo_count: #{options[:public_repo_count]}
  public_gist_count: #{options[:public_gist_count]}
  blog: #{options[:blog]}
  following_count: #{options[:following_count]}
  id: #{options[:id]}
  type: #{options[:type]}
  permission: #{options[:permission]}
  followers_count: #{options[:followers_count]}
  login: #{options[:login]}
  gravatar_id: #{options[:gravatar_id]}
  email: #{options[:email]}
  total_private_repo_count: #{options[:total_private_repo_count]}
  collaborators: #{options[:collaborators]}
  disk_usage: #{options[:disk_usage]}
  owned_private_repo_count: #{options[:owned_private_repo_count]}
  private_gist_count: #{options[:private_gist_count]}
  plan:
    name: #{options[:plan_name]}
    collaborators: #{options[:plan_collaborators]}
    space: #{options[:plan_space]}
    private_repos: #{options[:plan_private_repos]}
BODY
  

end

def stub_github_requests_for repo
  stub_anonymous_user_request(login: repo.owner)
  stub_anonymous_repo_request_from_factory repo
  stub_anonymous_repo_languages_request(languages: repo.languages)
end
